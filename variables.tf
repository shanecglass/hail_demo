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

# --------------------------------------------------
# VARIABLES
# Set these before applying the configuration
# --------------------------------------------------

#Update with your project ID
variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

#Update with your preferred region. Please consider the carbon footprint of your workload when choosing a region: https://cloud.google.com/sustainability/region-carbon#data
variable "region" {
  type        = string
  description = "Google Cloud Region"
  default     = "us-central1"
}

variable "bq_dataset_hail" {
  type        = string
  description = "BigQuery dataset ID"
  default     = "hail_demo"
}

variable "customer_table_id" {
  type        = string
  description = "BigQuery table ID for sample customer data"
  default     = "sample_customer_data"
}

variable "hail_event_table_id" {
  type = string
  description = "BigQuery table ID for sample hail event data"
  default = "hail_events"
}

variable "setup_bucket" {
  type = string
  description = "Name of the GCS bucket that holds the sample customer data"
  default = "gs://hail_demo_sample_data"
}

variable "gcs_hail_object_table_id" {
  type = string
  description = "BigQuery table ID for the GCS object table that holds hail inputs"
  default = "gcs_hail_inputs"
}

variable "customer_sample_data" {
  type = string
  description = "File name of sample customer data in the GCS bucket defined in var.setup_bucket"
  default = "us_banks.parquet"
}

variable "functions_source" {
  type = string
  description = "Name of the zip file uploaded to GCS that defines the Cloud Function"
  default = "geojson_loader.zip"
}

variable "labels" {
  type        = map(string)
  description = "A map of labels to apply to contained resources"
  default     = { "hail_demo" = true }
}

variable "enable_apis" {
  type        = string
  description = "Whether or not to enable underlying apis in this solution"
  default     = true
}

variable "force_destroy" {
  type        = string
  description = "Whether or not to protect BigQuery resources from deletion when solution is modified or changed"
  default     = false
}
