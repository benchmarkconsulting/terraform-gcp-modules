resource "google_compute_global_address" "global_address" {
  name          = var.name
  address_type  = var.address_type
  project       = var.project
}