############################
## Classic VPN GCP - Main ##
############################

# Create a Static IP for Classic VPN
resource "google_compute_address" "vpn-static-ip" {
  name    = "${var.name}-vpn-gateway-classic-ip"
  project = var.gcp_project
}

# Create a Classic VPN
resource "google_compute_vpn_gateway" "vpn-gateway-classic" {

  name    = "${var.name}-vpn-gateway-classic"
  project = var.gcp_project
  network = var.network_name
}

# VPN Forwarding Rule ESP
resource "google_compute_forwarding_rule" "vpn-fr-esp-classic" {
  name = "vpn-gateway-fr-esp"
  project = var.gcp_project
  ip_protocol = "ESP"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
}
# VPN Forwarding Rule UDP 500
resource "google_compute_forwarding_rule" "vpn-fr-udp500-classic" {
  name = "vpn-gateway-fr-udp500"
  project = var.gcp_project
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
}
# VPN Forwarding Rule UDP 4500
resource "google_compute_forwarding_rule" "vpn-fr-udp4500-classic" {
  name = "vpn-gateway-fr-udp4500"
  project = var.gcp_project
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
}

# VPN Router
resource "google_compute_router" "vpn-router-classic" {
  name    = "${var.name}-vpn-router-classic"
  project = var.gcp_project
  network = var.network_name

  bgp {
    asn = var.classic_vpn_router_asn
  }
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "vpn-tunnel-classic" {
  depends_on = [
    google_compute_forwarding_rule.vpn-fr-esp-classic,
    google_compute_forwarding_rule.vpn-fr-udp500-classic,
    google_compute_forwarding_rule.vpn-fr-udp4500-classic,
    google_compute_vpn_gateway.vpn-gateway-classic
  ]

  provider           = google-beta
  name               = "${var.name}-vpn-tunnel-classic"
  project            = var.gcp_project
  region             = var.gcp_region
  peer_ip            = var.classic_vpn_ext_gateway_ip
  shared_secret      = var.classic_vpn_shared_secret
  target_vpn_gateway = google_compute_vpn_gateway.vpn-gateway-classic.id
  router             = google_compute_router.vpn-router-classic.name
 }

# Create Router Interfaces
resource "google_compute_router_interface" "vpn-interface-classic" {
  depends_on = [google_compute_vpn_tunnel.vpn-tunnel-classic]

  name       = "${var.name}-vpn-router-interface-classic"
  project    = var.gcp_project 
  router     = google_compute_router.vpn-router-classic.name
  region     = var.gcp_region
  ip_range   = var.classic_vpn_router_interface_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.vpn-tunnel-classic.name
}

# Create Peers
resource "google_compute_router_peer" "vpn-peer-classic" {
  depends_on = [google_compute_router_interface.vpn-interface-classic]

  name                      = "${var.name}-vpn-router-peer-classic"
  project                   = var.gcp_project
  router                    = google_compute_router.vpn-router-classic.name
  region                    = var.gcp_region
  peer_ip_address           = var.classic_vpn_router_peer_ip_address
  peer_asn                  = var.classic_vpn_peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn-interface-classic.name
}