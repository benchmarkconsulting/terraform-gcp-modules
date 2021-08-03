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

variable "classic_vpn_shared_secret" {
  description = "Tunnel shared secret"
  type        = string
}

variable "dest_range" {
}