resource "random_id" "default" {
  byte_length = 8
}

#Create bucket for Cloud Function source
resource "google_storage_bucket" "function_source" {

  name                        = "${random_id.default.hex}-gcf-source" # Every bucket name must be globally unique
  location                    = "us-central1"
  uniform_bucket_level_access = true
  depends_on = [ time_sleep.wait_after_apis_activate ]
}

# Define/create zip file for Cloud Function source
data "archive_file" "create_function_zip" {
  type        = "zip"
  output_path = "${path.root}/tmp/${var.functions_source}"
  source_dir  = "${path.root}/cloud_function/"
  depends_on = [ time_sleep.wait_after_apis_activate ]

}

# Upload Cloud Function source zip file
resource "google_storage_bucket_object" "function_upload" {
  name   = var.functions_source
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.create_function_zip.output_path # Add path to the zipped function source code
  depends_on = [  data.archive_file.create_function_zip, google_storage_bucket.function_source  ]
}

# Create bucket for sample hail events
resource "google_storage_bucket" "geojson_bucket" {
  name                        = "${random_id.default.hex}-geojson-bucket" # Every bucket name must be globally unique
  location                    = "us-central1"
  uniform_bucket_level_access = true
  depends_on = [ time_sleep.wait_after_apis_activate ]
}

# Upload sample hail events file
resource "google_storage_bucket_object" "geojson_upload" {
  name   = "input/dayone_hail.geojson"
  bucket = google_storage_bucket.geojson_bucket.name
  source = "${path.root}/input/hail_forecast.geojson"

  depends_on = [ google_storage_bucket.geojson_bucket ]
}
