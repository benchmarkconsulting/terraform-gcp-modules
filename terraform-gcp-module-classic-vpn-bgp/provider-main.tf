#####################
## Provider - Main ##
#####################

terraform {
  required_version = ">= 0.13"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "google-beta" {
  project = var.gcp_project
  region  = var.gcp_region
}
