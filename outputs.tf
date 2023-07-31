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

output "create_remote_function_cli" {
  value = <<EOT
  "bq query -- project_id ${var.project_id} \ --use_legacy_sql=false \
  """
  CREATE OR REPLACE FUNCTION `${module.project-services.project_id}.${google_bigquery_dataset.dest_dataset.dataset_id}`.geojson_loader(gcs_uri STRING) RETURNS STRING REMOTE WITH CONNECTION `${module.project-services.project_id}.${var.region}.${var.bq_connection_id}` OPTIONS (endpoint = '${google_cloudfunctions2_function.geojson_load.url}')
  """
  EOT
  description = "Copy and paste this into the CLI to create the remote function"
}

output "dataform_repo_url" {
  value       = "https://console.cloud.google.com/bigquery/dataform/locations/us-central1/repositories/${google_dataform_repository.cleaning_repo.name}/details/workspaces?project=${var.project_id}"
  description = "The URL to launch the Dataform UI for the repo created"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}"
  description = "The URL to launch the BigQuery editor"
}

output "looker_studio_report_url" {

  value       = "https://lookerstudio.google.com/c/reporting/create?c.reportId=92730323-a315-44ad-8fee-0c520f6397aa&ds.hail_impacts.datasourceName=hail_customers&ds.hail_impacts.projectId=${var.project_id}&ds.hail_impacts.type=TABLE&ds.hail_impacts.datasetId=${google_bigquery_dataset.dest_dataset.dataset_id}&ds.hail_impacts.tableId=customers_impacted"
  description = "The URL to create a new Looker Studio report with a sample dashboard for the data"
}
