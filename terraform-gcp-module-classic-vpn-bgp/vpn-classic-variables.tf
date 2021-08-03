#############################
## Classic VPN - Variables ##
#############################

variable "name" {
  description = "Prefix used for resources that need unique names"
  type        = string
}

variable "network_name" {
  type        = string
}

variable "classic_vpn_ext_gateway_ip" {
  type        = string
  description = "Public IP of the external VPN Gateway"
}

variable "classic_vpn_router_asn" {
  description = "ASN for local side of BGP sessions"
  type        = string
  default     = "64514"
}

variable "classic_vpn_peer_asn" {
  description = "ASN for local side of BGP sessions"
  type        = string
  default     = "64515"
}

variable "classic_vpn_shared_secret" {
  description = "Tunnel shared secret"
  type        = string
}

variable "classic_vpn_router_interface_ip_range" {
  description = "Router Interface IP Range"
  type        = string
}

variable "classic_vpn_router_peer_ip_address" {
  description = "Router Peer IP Address"
  type        = string
}
