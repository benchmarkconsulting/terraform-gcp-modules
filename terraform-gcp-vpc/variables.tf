variable "project_id" {
  description = "The ID of the project where this VPC will be created"
}

variable "create_network" {
  type        = bool
  default     = true
  description = "Specify whether to create a new network or just assume it already exists."
}

variable "network_name" {
    description = "The name of the VPC being created."
    type        = string
}    

variable "auto_create_subnetworks" {
    description = "If set to true, this network will be created in auto subnet mode, and Google will create a subnet for each region automatically. If set to false, a custom subnetted network will be created that can support google_compute_subnetwork resources."
    type        = string
    default     = "true"
}
variable "shared_vpc_host" {
  type        = string
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = "false"
}

variable "routing_mode" {
    description = "Sets the network-wide routing mode for Cloud Routers to use. Accepted values are GLOBAL or REGIONAL."
    type        = string
    default     = "GLOBAL"
}           

variable "subnet" {
  type        = list(map(string))
  description = "The list of subnets being created"
}
           
variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}