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
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "14.2.1"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudrun.googleapis.com",
    "config.googleapis.com",
    "dataform.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
  ]
  activate_api_identities = [{
      api = "bigquery.googleapis.com"
      roles = [
        "roles/bigquery.Admin",                 // Needs to create datasets, create tables, update tables, set IAM policy
      ]
    },
    {
      api = "cloudfunctions.googleapis.com"
      roles = [
        "roles/cloudfunctions.developer",       // Needs to create and update functions
        "roles/cloudfunctions.invoker",         // Service account role to create/run remote function
]
    },
    {
      api = "cloudrun.googleapis.com"
      roles = [
        "roles/run.developer",                  // Needs to deploy, invoke, and set IAM policy
        "roles/run.invoker",                    // Service account role to create/run remote function
      ]
    },
    {
      api = "dataform.googleapis.com"
      roles = [
        "roles/dataform.admin",                 // Needs to create repos; create, commit, and invoke workspaces; Set IAM policy for workspaces and repos; Pull files; Invoke workflows
      ]
    },
    {
      api = "logging.googleapis.com"
      roles = [
        "roles/logging.logWriter",              // Needs to write log entries
      ]
    },
    {
      api = "storage.googleapis.com"
      roles = [
        "roles/storage.Admin",                  //Needs to create buckets and edit objects
        "roles/storage.ObjectViewer"            //Service account role to create GCS Object Table in BigQuery
      ]
    },
  ]
}
