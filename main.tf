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

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

module "project-services" {
  source = "./module-project-services"
}

resource "time_sleep" "wait_after_apis_activate" {
  depends_on      = [module.project-services]
  create_duration = "60s"
}

resource "google_project_service_identity" "cloud_functions" {
  provider = google-beta
  project  = module.project-services.project_id
  service  = "cloudfunctions.googleapis.com"

  depends_on = [time_sleep.wait_after_apis_activate]
}

resource "google_service_account" "cloud_function_manage_sa" {
  project      = module.project-services.project_id
  account_id   = "hail-demo"
  display_name = "Cloud Functions Service Account"

  depends_on = [google_project_service_identity.cloud_functions]
}

resource "google_project_iam_member" "function_manage_roles" {
  for_each = toset([
    "roles/cloudfunctions.admin",         // Service account role to manage access to the remote function
    "roles/storage.objectAdmin",          // Read/write GCS files
    "roles/storage.legacyBucketWriter"    // Read/write GCS files
    ]
  )
  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_service_account.cloud_function_manage_sa.email}"

  depends_on = [google_service_account.cloud_function_manage_sa]
}

resource "time_sleep" "wait_after_all_resources" {
  create_duration = "120s"
  depends_on = [
    module.project-services,
    google_project_iam_member.function_manage_roles,
    google_bigquery_dataset.dest_dataset,
    google_bigquery_table.dest_table_customer,
    google_bigquery_table.dest_table_hail,
    google_bigquery_job.load_samples_customer,
    google_cloudfunctions2_function.geojson_load,
    google_bigquery_connection.function_connection,
    google_service_account.bq_connection_sa,
    google_project_iam_member.functions_invoke_roles,
    google_bigquery_table.gcs_objects_hail,
    google_bigquery_routine.remote_function,
    google_dataform_repository.cleaning_repo
  ]
}
