variable "router_name" {
    description = "name for the NAT router."
    type        = string
}

variable "nat_name" {
    description = "name for the NAT."
    type        = string
}

variable "nat_logging" {
    description = "Logging enabled/disabled."
    type        = string
    default     = "false"
}

variable "network_name" {
    description = "vpc_network"
    type        = string
}