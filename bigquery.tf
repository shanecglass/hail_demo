/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



#Create dataset for sample hail events and sample customer data
resource "google_bigquery_dataset" "dest_dataset" {
  project             = module.project-services.project_id
  dataset_id          = var.bq_dataset_hail
  location            = var.region
  depends_on          = [ time_sleep.wait_after_apis_activate]
}

#Create table for sample customer data
resource "google_bigquery_table" "dest_table_customer" {
  project             = module.project-services.project_id
  dataset_id          = google_bigquery_dataset.dest_dataset.dataset_id
  table_id            = var.customer_table_id
  deletion_protection = false

  schema = <<EOF
  [
    {
      "name": "primary_key_id",
      "type": "STRING"
    },
    {
      "description": "A unique number assigned by the FDIC used to identify institutions and for the issuance of insurance certificates.",
      "name": "fdic_certificate_number",
      "type": "STRING"
    },
    {
      "description": "The legal name of the institution.",
      "name": "institution_name",
      "type": "STRING"
    },
    {
      "description": "Name of the branch.",
      "name": "branch_name",
      "type": "STRING"
    },
    {
      "description": "The branch's corresponding office number.",
      "name": "branch_number",
      "type": "STRING"
    },
    {
      "description": "Identifies whether or not this is the main office for the institution",
      "name": "main_office",
      "type": "BOOLEAN"
    },
    {
      "description": "Street address at which the branch is physically located.",
      "name": "branch_address",
      "type": "STRING"
    },
    {
      "description": "City in which branch is physically located.",
      "name": "branch_city",
      "type": "STRING"
    },
    {
      "description": "The first five digits of the full postal zip code representing physical location of the branch.",
      "name": "zip_code",
      "type": "STRING"
    },
    {
      "description": "County where the branch is physically located.",
      "name": "branch_county",
      "type": "STRING"
    },
    {
      "description": "A five digit number representing the state and county in which the institution is physically located. The first two digits represent the FIPS state numeric code and the last three digits represent the FIPS county numeric code.",
      "name": "county_fips_code",
      "type": "STRING"
    },
    {
      "description": "State abbreviation in which the branch is physically located. The FDIC Act defines state as any State of the United States, the District of Columbia, and any territory of the United States, Puerto Rico, Guam, American Samoa, the Trust Territory of the Pacific Islands, the Virgin Island, and the Northern Mariana Islands.",
      "name": "state",
      "type": "STRING"
    },
    {
      "description": "Full-text name of the state in which the branch is physically located. The FDIC Act defines state as any State of the United States, the District of Columbia, and any territory of the United States, Puerto Rico, Guam, American Samoa, the Trust Territory of the Pacific Islands, the Virgin Island, and the Northern Mariana Islands.",
      "name": "state_name",
      "type": "STRING"
    },
    {
      "description": "A classification code assigned by the FDIC based on the institution's charter type (commercial bank or savings institution), charter agent (state or federal), Federal Reserve membership status (Fed member, Fed nonmember) and its primary federal regulator (state chartered institutions are subject to both federal and state supervision). N -Commercial bank, national (federal) charter and Fed member, supervised by the Office of the Comptroller of the Currency (OCC) NM -Commercial bank, state charter and Fed nonmember, supervised by the FDIC OI - Insured U.S. branch of a foreign chartered institution (IBA) SA - Savings associations, state or federal charter, supervised by the Office of Thrift Supervision (OTS) SB - Savings banks, state charter, supervised by the FDIC SM - Commercial bank, state charter and Fed member, supervised by the Federal Reserve (FRB)",
      "name": "institution_class",
      "type": "STRING"
    },
    {
      "description": "Numeric code of the Core Based Statistical Area (CBSA) as defined by the US Census Bureau Office of Management and Budget.",
      "name": "cbsa_fips_code",
      "type": "STRING"
    },
    {
      "description": "A flag indicating member of a Core Based Statistical Division as defined by the US Census Bureau Office of Management and Budget.",
      "name": "cbsa_division_flag",
      "type": "BOOLEAN"
    },
    {
      "name": "cbsa_division_fips_code",
      "type": "STRING"
    },
    {
      "description": "A flag used to indicate whether an branch is in a Metropolitan Statistical Area as defined by the US Census Bureau Office of Management and Budget",
      "name": "cbsa_metro_flag",
      "type": "BOOLEAN"
    },
    {
      "description": "Numeric code of the Metropolitan Statistical Area as defined by the US Census Bureau Office of Management and Budget",
      "name": "cbsa_metro_fips_code",
      "type": "STRING"
    },
    {
      "description": "A flag used to indicate whether an branch is in a Micropolitan Statistical Area as defined by the US Census Bureau Office of Management and Budget",
      "name": "cbsa_micro_flag",
      "type": "BOOLEAN"
    },
    {
      "description": "Flag indicating member of a Combined Statistical Area (CSA) as defined by the US Census Bureau Office of Management and Budget\t",
      "name": "csa_flag",
      "type": "BOOLEAN"
    },
    {
      "description": "Numeric code of the Combined Statistical Area (CSA) as defined by the US Census Bureau Office of Management and Budget\t",
      "name": "csa_fips_code",
      "type": "STRING"
    },
    {
      "description": "The date on which the branch began operations.",
      "name": "date_established",
      "type": "STRING"
    },
    {
      "description": "\tThis is the FDIC UNINUM of the institution that owns the branch. A UNINUM is a unique sequentially number added to the FDIC database for both banks and branches. There is no pattern imbedded within the number. The FI_UNINUM is updated with every merger or purchase of branches to reflect the most current owner.",
      "name": "fdic_uninum",
      "type": "STRING"
    },
    {
      "description": "\tThe day the institution information was updated.",
      "name": "last_updated",
      "type": "STRING"
    },
    {
      "description": "Define the various types of offices of FDIC-insured institutions. 11 - Full Service Brick and Mortar Office 12 - Full Service Retail Office 13 - Full Service Cyber Office 14 - Full Service Mobile Office 15 - Full Service Home/Phone Banking 16 - Full Service Seasonal Office 21 - Limited Service Administrative Office 22 - Limited Service Military Facility 23 - Limited Service Facility Office 24 - Limited Service Loan Production Office 25 - Limited Service Consumer Credit Office 26 - Limited Service Contractual Office 27 - Limited Service Messenger Office 28 - Limited Service Retail Office 29 - Limited Service Mobile Office 30 - Limited Service Trust Office",
      "name": "service_type",
      "type": "STRING"
    },
    {
      "description": "Unique Identification Number for a Branch Office as assigned by the FDIC",
      "name": "branch_fdic_uninum",
      "type": "STRING"
    },
    {
      "description": "Geographic representation of the bank's physical location",
      "name": "bank_geom",
      "type": "STRING"
    }]
  EOF
  depends_on = [ google_bigquery_dataset.dest_dataset ]
}

#Load sample customer data to BigQuery
resource "google_bigquery_job" "load_samples_customer" {
  job_id = "load_sample_customers"
  labels = {
    "my_job" ="load"
  }

  load {
    source_uris = ["${var.setup_bucket}/${var.customer_sample_data}"]

    destination_table {
      project    = module.project-services.project_id
      dataset_id = google_bigquery_dataset.dest_dataset.dataset_id
      table_id   = google_bigquery_table.dest_table_customer.table_id
    }
    write_disposition     = "WRITE_EMPTY"
    source_format         = "PARQUET"
    autodetect            = false
  }
  depends_on = [google_bigquery_dataset.dest_dataset, google_bigquery_table.dest_table_customer]

}

#Create table for sample hail event data
resource "google_bigquery_table" "dest_tables_hail" {
  project             = module.project-services.project_id
  dataset_id          = google_bigquery_dataset.dest_dataset.dataset_id
  table_id            = var.hail_event_table_id
  deletion_protection = false

  time_partitioning {
    field             = "publish_time"
    type              = "HOUR"
  }

  schema = <<EOF
[
  {
    "mode": "NULLABLE",
    "name": "DN",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "VALID",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "EXPIRE",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "ISSUE",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "LABEL",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "LABEL2",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "stroke",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "fill",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "geometry",
    "type": "GEOGRAPHY"
  }]
EOF
  depends_on = [google_bigquery_dataset.dest_dataset]
}

#Create BigQuery connection for Cloud Functions and GCS
resource "google_bigquery_connection" "function_connection" {
    connection_id = "geojson-ingest"
    location      = "us-central1"
    friendly_name = "GeoJSON Loader"
    description   = "Connecting to the remote function that converts GeoJSON files to Newline Delimited JSON and loads to BQ"
    cloud_resource {}
    depends_on    = [ time_sleep.wait_after_apis_activate ]

}

#Pull service account email that was created for BigQuery Connection
data "google_service_account" "bq_connection_sa" {
  account_id = google_bigquery_connection.function_connection.id
  depends_on = [google_bigquery_connection.function_connection]
}

#Grant connection service account necessary permissions
resource "google_project_iam_member" "functions_invoke_roles" {
  for_each = toset([
    "roles/run.invoker",                    // Service account role to invoke the remote function
    "roles/cloudfunctions.invoker",         // Service account role to invoke the remote function
    "roles/storage.objectViewer",            // View GCS objects to create object tables
    "roles/iam.serviceAccountUser"
    ]
  )
  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_service_account.bq_connection_sa.email}"

  depends_on = [data.google_service_account.bq_connection_sa]
}

#Create GCS object table for sample hail event data. This is what input table for the remote function
resource "google_bigquery_table" "gcs_objects_hail" {
  project             = module.project-services.project_id
  dataset_id          = google_bigquery_dataset.dest_dataset.dataset_id
  table_id            = var.gcs_hail_object_table_id
  deletion_protection = false

  external_data_configuration{
    autodetect = true
    connection_id = google_bigquery_connection.function_connection.id
    source_uris = ["${google_storage_bucket.geojson_bucket.url}/input/*"]
    object_metadata = "Simple"
  }

  depends_on = [google_project_iam_member.functions_invoke_roles, google_storage_bucket_object.geojson_upload, google_bigquery_dataset.dest_dataset]
}

# Create remote function that takes input from GCS object table and sends that to the Cloud Function
resource "google_bigquery_routine" "remote_function" {
  dataset_id = google_bigquery_dataset.dest_dataset.dataset_id
  routine_id     = "geojson_loader"
  routine_type = "PROCEDURE"
  language = "SQL"
  definition_body = "CREATE FUNCTION `${module.project-services.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}`.geojson_loader(gcs_uri STRING) RETURNS STRING REMOTE WITH CONNECTION `${module.project-services.project_id}.${var.region}.${google_bigquery_connection.function_connection.name}` OPTIONS (endpoint = '${google_cloudfunctions2_function.geojson_load.service_config[0].uri}')"

  depends_on = [google_cloudfunctions2_function.geojson_load, google_project_iam_member.functions_invoke_roles]
}

# Create Dataform repository
resource "google_dataform_repository" "cleaning_repo" {
  provider            = google-beta
  name                = "Hail_Demo"

  workspace_compilation_overrides {
    default_database  = module.project-services.project_id
  }

  depends_on          = [time_sleep.wait_after_apis_activate ]
}

