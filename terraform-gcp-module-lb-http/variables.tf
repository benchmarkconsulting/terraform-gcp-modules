##### Common Variables #####
variable "gcp_project" {
  type        = string
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable "region" {
  type        = string
  description = "Region used for GCP resources."
  default     = "northamerica-northeast1"
}

variable "name" {
  type        = string
  description = "Name prefix for supporting resources."
}

#### Unmanaged Instance group variables
variable "named_port" {
  description = "Instance group ports to determine whether instances are responsive and able to do work"
  type = object({
    port = number
    name = string
  })
  default = {
    port = null
    name = null
  }
}

variable "instances" {
  description = "GCE resources to add to the instance group."
  default     = ""
}

variable "zone" {
  description = "GCE zone to add to the instance group."
  default     = ""
}

#### backend vars ####
variable "backend_protocol" {
  type        = string
  description = "Protocol the backend should be listneing on"
  default     = "https"
}

variable "backend_port" {
  type        = string
  description = "Port the backend should be listneing on"
  default     = 443
}

// variable "backend" {
//   type = list
// }

variable "backends" {
  description = "Map backend indices to list of backend maps."
  type = map(object({
    groups = list(object({
      group = string

    }))
  }))
}


variable "session_affinity" {
  type        = string
  description = "How to distribute load. Options are `NONE`, `CLIENT_IP` and `CLIENT_IP_PROTO`"
  default     = "NONE"
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    port                = number
    request_path        = string
  })
  # default = {
  #   check_interval_sec  = null
  #   healthy_threshold   = null
  #   timeout_sec         = null
  #   unhealthy_threshold = null
  #   port                = null
  #   request_path        = null
  # }
}

variable "forwarding_address" {
  description = "IP address of the external load balancer, if empty one will be assigned."
  default     = null
}

variable "forwarding_protocol" {
  description = "The IP protocol for the frontend forwarding rule and firewall rule. TCP, UDP, ESP, AH, SCTP or ICMP."
  default     = "TCP"
}

variable "forwarding_port" {
  description = "The IP protocol for the frontend forwarding rule and firewall rule. TCP, UDP, ESP, AH, SCTP or ICMP."
  default     = 443
}

##### Health Check Variables


variable "domains" {
  description = "domains for the google managed certificate."
}

variable "logging" {
  description = ""
  default     = false
}