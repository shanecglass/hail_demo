resource "google_cloudfunctions2_function" "geojson_load" {
  name = "geojson-ingest"
  location = "us-central1"
  description = "Convert GeoJSON to New-Line Delimited GeoJSON and load to BigQuery"

  build_config {
    runtime = "python311"
    entry_point = "run_it"  # Set the entry point

    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_upload.name
      }
    }
    environment_variables = {
      "OUTPUT_BUCKET":"${substr(google_storage_bucket.geojson_bucket.url, 3, -1)}",
      "PROJ":"${module.project-services.project_id}",
      "REGION":"${var.region}"}
  }

  service_config {
    max_instance_count  = 10
    min_instance_count = 1
    available_memory    = "2Gi"
    timeout_seconds     = 300
    max_instance_request_concurrency = 1
    available_cpu = "4"
    ingress_settings = "ALLOW_ALL"
    all_traffic_on_latest_revision = true
    service_account_email = google_service_account.cloud_function_manage_sa.email
  }

  depends_on = [google_storage_bucket_object.function_upload, google_project_iam_member.function_manage_roles]

}
