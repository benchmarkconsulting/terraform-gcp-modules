resource "google_compute_router" "router"{
    name    = var.router_name
    network = var.network_name
}

resource "google_compute_router_nat" "nat" {
    name                               = var.nat_name
    router                             = google_compute_router.router.name
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    log_config {
      enable = var.nat_logging
      filter = "ERRORS_ONLY"
    }
}