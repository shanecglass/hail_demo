import functions_framework
import google.cloud.bigquery as bigquery
import google.cloud.storage as gcs
from google.cloud.storage import Blob
import json
import logging
import os
import os.path
import tempfile


tmpdir = tempfile.mkdtemp()
converted_file = os.path.join(tmpdir, 'to_load.json')

@functions_framework.http
def list_gcs_files(request):
  print(request)
  try:
    request_json = request.get_json()
    calls = request_json['calls']
    for call in calls:
      gsutil_link = str(call[0])
      print(gsutil_link)
    return gsutil_link
  except Exception as e:
    return json.dumps({"errorMessage": str(e)}), 400

def copy_fromgcs(blob_name, destdir, basename):
  client = gcs.Client()
  blob = Blob.from_string(blob_name, client=client)
  logging.info('Downloading {}'.format(blob))
  dest = os.path.join(destdir, basename)
  blob.download_to_filename(dest)
  return dest

def convert_to_newline(local_file, converted_file):
  with open(local_file, 'r') as ifp:
    with open(converted_file, 'w') as ofp:
      features = json.load(ifp)['features']
      print(features)
      # new-line-separated JSON
      for obj in features:
          props = obj['properties']  # a dictionary
          props['geometry'] = json.dumps(obj['geometry'])
          print(props)
          json.dump(props, fp=ofp)
          print('', file=ofp) # newline
          schema = []
          for key, value in props.items():
            if key == 'geometry':
              schema.append(bigquery.SchemaField(f'{key}', 'GEOGRAPHY', mode='NULLABLE'))
            elif isinstance(value, str):
              schema.append(bigquery.SchemaField(f'{key}', 'STRING', mode='NULLABLE'))
            else:
              schema.append(bigquery.SchemaField(f'{key}','{}'.format('INT64' if isinstance(value, int) else 'FLOAT64'), mode="NULLABLE"))
  print(schema)
  return(schema)

def download_to_local(request, outfilename, tmpdir):
  list_local_files = []
  local_file = copy_fromgcs(
    list_gcs_files(request), tmpdir, outfilename)
  # logging.info('Creating image from {} near {},{}'.format(
  #   outfilename))
  list_local_files.append(local_file)
  print(list_local_files)
  local_base_name = []
  for file in list_local_files:
    file_name = os.path.basename(file)
    local_base_name.append(file_name)
  print(local_base_name)
  print(f'{local_file} created')
  return(local_file)

def upload_to_gcs(output_bucket_name, source_file_name, destination_blob_name):
  print(output_bucket_name)
  client = gcs.Client()
  print(client)
  bucket = client.bucket(output_bucket_name)
  print(bucket)
  blob = bucket.blob(f"output/{destination_blob_name}")
  print(f"Blob is: {blob}")
  blob.upload_from_filename(source_file_name)
  print(f"gs://{output_bucket_name}/output/{destination_blob_name}")
  return(f"gs://{output_bucket_name}/output/{destination_blob_name}")

def load_to_bq(dest_table, local_json_schema, file_uri, place):
  client = bigquery.Client()
  if dest_table != None:
    job_config = bigquery.LoadJobConfig(
      schema=local_json_schema,
      write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
      source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
    )
    load_job = client.load_table_from_uri(
      file_uri,
      dest_table,
      location=place,  # Must match the destination dataset location.
      job_config=job_config,
    )
    load_job.result()  # Waits for the job to complete.
    destination_table = client.get_table(dest_table)
    print(f"Loaded {destination_table.num_rows} rows to BigQuery.")
    return(f"Loaded {destination_table.num_rows} rows to BigQuery.")
  else:
  # cleanup
   logging.info('Created {} from {}'.format(
      converted_file, os.path.basename(converted_file)))

def run_it(request):
  try:
    return_value = []
    dest_bucket = os.environ.get("OUTPUT_BUCKET")
    print(dest_bucket)
    project_id = os.environ.get("PROJECT_ID")
    print(dest_bucket)
    region = os.environ.get("REGION")
    print(region)
    local_outfile_name = "dayone_hail_forecast.geojson"
    output_table = f"{project_id}.hail_demo.hail_events"
    local_geojson = download_to_local(request, local_outfile_name, tmpdir)
    input_schema = convert_to_newline(local_geojson, converted_file)
    gcs_uri = upload_to_gcs(dest_bucket, converted_file, "to_load.json")
    output_tables = load_to_bq(output_table, input_schema, gcs_uri, region)
    return_value.append(output_tables)
    return_json = json.dumps({"replies": return_value})
    return return_json
  except Exception as e:
    return json.dumps({"errorMessage": str(e)}), 400
