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

output "dataform_repo_url" {
  value       = "https://console.cloud.google.com/bigquery/dataform/locations/us-central1/repositories/${google_dataform_repository.cleaning_repo.name}/details/workspaces?project=${var.project_id}"
  description = "The URL to launch the Dataform UI for the repo created"
}

output "output_bucket_id" {
  value       = "${substr(google_storage_bucket.geojson_bucket.url, 3, -1)}"
  description = "The URI of the GCS bucket where the newline-delimited GeoJSON file will be written. Copy and paste this into line 6 of load_geojson.sqlx"
}

output "remote_function_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_routine.remote_function.id}"
  description = "Fully qualified ID of the remote function routine that executes the load of GeoJSON data into BigQuery. Copy and paste this into line 6 of load_geojson.sqlx"
}

output "hail_input_object_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.gcs_objects_hail.table_id}"
  description = "Fully qualified ID of the object table of GeoJSON files. Copy and paste this into line 8 of load_geojson.sqlx"
}

output "customer_data_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.dest_table_customer.table_id}"
  description = "Fully qualified ID of the table that contains the sample customer data. Copy and paste this into line 40 of convert_customer_geog.sqlx"
}

output "hail_data_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.dest_tables_hail.table_id}"
  description = "Fully qualified ID of the table that contains the sample hail event data. Copy and paste this into line 51 of customers_impacted.sqlx"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}"
  description = "The URL to launch the BigQuery editor"
}

