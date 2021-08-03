resource "google_compute_interconnect_attachment" "megaport" {
  name                     = "${var.name}-interconnect"
  project                  = var.project
  region                   = var.region
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  description              = var.description
  router                   = google_compute_router.megaport.id
  mtu                      = 1500
}

resource "google_compute_router" "megaport" {
  name    = "${var.name}-router"
  project = var.project
  region  = var.region
  network = var.network_name
  bgp {
    asn = 16550
  }
}