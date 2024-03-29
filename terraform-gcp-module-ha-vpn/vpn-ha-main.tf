###################
## HA VPN - Main ##
###################

# Create VPN Gateway
resource "google_compute_ha_vpn_gateway" "vpn-gateway-ha" {

  provider = google-beta
  region   = var.gcp_region
  name     = "vpn-gateway"
  project  = var.gcp_project
  network  = var.network_name
}

# Create a VPN External Gateway
resource "google_compute_external_vpn_gateway" "vpn-external-gateway-ha" {
  provider        = google-beta
  name            = "external-vpn-gateway-ha"
  project         = var.gcp_project
  redundancy_type = "TWO_IPS_REDUNDANCY"
  description     = "An externally managed VPN gateway"

  interface {
    id         = 0
    ip_address = var.ha_ext_vpn_gateway_ip_1
  }

  interface {
    id         = 1
    ip_address = var.ha_ext_vpn_gateway_ip_2
  }
}

# Create VPN Tunnel 1
resource "google_compute_vpn_tunnel" "vpn-tunnel1-ha" {
  provider                        = google-beta
  name                            = "${var.name}-vpn-tunnel1-ha"
  project                         = var.gcp_project
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn-gateway-ha.id
  peer_external_gateway           = google_compute_external_vpn_gateway.vpn-external-gateway-ha.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.ha_shared_secret
  router                          = google_compute_router.vpn-router-ha.id
  vpn_gateway_interface           = 0
}

# Create VPN Tunnel 2
resource "google_compute_vpn_tunnel" "vpn-tunnel2-ha" {
  provider                        = google-beta
  name                            = "${var.name}-vpn-tunnel2-ha"
  project                         = var.gcp_project
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpn-gateway-ha.id
  peer_external_gateway           = google_compute_external_vpn_gateway.vpn-external-gateway-ha.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.ha_shared_secret
  router                          = google_compute_router.vpn-router-ha.id
  vpn_gateway_interface           = 1
}

# Create Cloud Router
resource "google_compute_router" "vpn-router-ha" {

  name    = "${var.name}-cloud-router-ha"
  project  = var.gcp_project
  network  = var.network_name
  bgp {
    asn = var.ha_router_asn
  }
}

# Create Cloud Router Interface 1
resource "google_compute_router_interface" "vpn-router-interface1-ha" {
  depends_on = [
    google_compute_router.vpn-router-ha
  ]

  provider   = google-beta
  name       = "${var.name}-cloud-router-interface1-ha"
  project    = var.gcp_project
  router     = google_compute_router.vpn-router-ha.name
  region     = var.gcp_region
  ip_range   = var.ha_router_interface1_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.vpn-tunnel1-ha.name
}

# Create Cloud Router Peer 1
resource "google_compute_router_peer" "vpn-router-peer1-ha" {
  depends_on = [
    google_compute_router.vpn-router-ha
  ]

  provider                  = google-beta
  name                      = "${var.name}-cloud-router-peer1-ha"
  project                   = var.gcp_project
  router                    = google_compute_router.vpn-router-ha.name
  region                    = var.gcp_region
  peer_ip_address           = var.ha_router_peer1_ip_address
  peer_asn                  = var.ha_peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn-router-interface1-ha.name
}

# Create Cloud Router Interface 2
resource "google_compute_router_interface" "vpn-router-interface2-ha" {
  depends_on = [
    google_compute_router.vpn-router-ha
  ]

  provider   = google-beta
  name       = "${var.name}-cloud-router-interface2-ha"
  project    = var.gcp_project
  router     = google_compute_router.vpn-router-ha.name
  region     = var.gcp_region
  ip_range   = var.ha_router_interface2_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.vpn-tunnel2-ha.name
}

# Create Cloud Router Peer 2
resource "google_compute_router_peer" "vpn-router-peer2-ha" {
  depends_on = [
    google_compute_router.vpn-router-ha
  ]

  provider                  = google-beta
  name                      = "${var.name}-cloud-router-peer2-ha"
  project                   = var.gcp_project
  router                    = google_compute_router.vpn-router-ha.name
  region                    = var.gcp_region
  peer_ip_address           = var.ha_router_peer2_ip_address
  peer_asn                  = var.ha_peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn-router-interface2-ha.name
}
