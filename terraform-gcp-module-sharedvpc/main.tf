/******************************************
  Project random id suffix configuration
 *****************************************/
resource "random_id" "random_project_id_suffix" {
  byte_length = 2
}
locals {
  base_project_id = var.name
  temp_project_id = format(
    "%s-%s",
    local.base_project_id,
    random_id.random_project_id_suffix.hex,
  )
}
/*******************************************
  Project creation
 *******************************************/
resource "google_project" "main" {
  name                = var.name
  project_id          = local.temp_project_id
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
  labels              = var.labels
}

/******************************************
	VPC configuration
 *****************************************/
resource "google_compute_network" "network" {
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  project                         = var.project_id
  description                     = var.description
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.mtu
}

/******************************************
  Shared VPC configuration
 *****************************************/

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  provider   = google-beta
  count      = var.enable_shared_vpc_host_project ? 1 : 0
  project    = google_project.main.project_id
  depends_on = [google_project.main]
}