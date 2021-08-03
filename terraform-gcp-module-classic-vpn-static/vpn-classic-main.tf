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
  name = "${var.name}-vpn-gateway-fr-esp"
  project = var.gcp_project
  ip_protocol = "ESP"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
}
# VPN Forwarding Rule UDP 500
resource "google_compute_forwarding_rule" "vpn-fr-udp500-classic" {
  name = "${var.name}-vpn-gateway-fr-udp500"
  project = var.gcp_project
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
}
# VPN Forwarding Rule UDP 4500
resource "google_compute_forwarding_rule" "vpn-fr-udp4500-classic" {
  name = "${var.name}-vpn-gateway-fr-udp4500"
  project = var.gcp_project
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.vpn-static-ip.address
  target = google_compute_vpn_gateway.vpn-gateway-classic.id
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
  local_traffic_selector = ["10.30.0.0/15"]
  remote_traffic_selector = ["10.1.72.0/23"]
  ike_version = 2 
 }

 resource "google_compute_route" "vpn-route-classic" {
  for_each = toset(var.dest_range)
  name       = "${var.name}-vpn-route-${index(var.dest_range, each.key)}"
  network = var.network_name
  #dest_range = var.dest_range
  dest_range = each.key
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn-tunnel-classic.id
}