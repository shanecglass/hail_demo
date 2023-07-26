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

output "remote_function_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_routine.remote_function.id}"
  description = "Fully qualified ID of the remote function routine that executes the load of GeoJSON data into BigQuery"
}

output "hail_input_object_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.gcs_objects_hail.table_id}"
  description = "Fully qualified ID of the object table of GeoJSON files"
}

output "customer_data_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.dest_table_customer.table_id}"
  description = "Fully qualified ID of the table that contains the sample customer data"
}

output "hail_data_table_id" {
  value = "${var.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}.${google_bigquery_table.dest_table_hail.table_id}"
  description = "Fully qualified ID of the table that contains the sample hail event data. Copy and paste this into line 51 of customers_impacted.sqlx"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}"
  description = "The URL to launch the BigQuery editor"
}

output "looker_studio_report_url" {

  value       = "https://lookerstudio.google.com/c/reporting/create?c.reportId=92730323-a315-44ad-8fee-0c520f6397aa&ds.hail_impacts.datasourceName=hail_customers&ds.hail_impacts.projectId=${var.project_id}&ds.hail_impacts.type=TABLE&ds.hail_impacts.datasetId=${google_bigquery_dataset.dest_dataset.dataset_id}&ds.hail_impacts.tableId=customers_impacted"
  description = "The URL to create a new Looker Studio report with a sample dashboard for the data"
}
