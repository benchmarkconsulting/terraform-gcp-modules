variable "project" {
  description = "GCP project id for the load balancer"
  default     = ""
}


variable "region" {
  description = "GCP region for the load balancer"
  default     = ""
}

variable "zone" {
  type        = string
  description = "Zone ot deploy the machine in"
  default     = "us-east1-b"
}

variable "instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "vm_name" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = "terraformvm"
}

variable "machine_type" {
  type        = string
  description = "GCP compute type."
  default     = "n1-standard-1"
}

variable "image" {
  type        = string
  description = "OS image to use for compute instance"
  default     = ""
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}

variable "tags" {
  type        = list(string)
  description = "any tags you want to add to the image"
}

variable "disk_size_gb" {
  type        = string
  description = "size of the image if different then the base"
  default     = "50"
}

variable "data_disk_size_gb" {
  description = "size of the disk"
  default     = null
}

variable "subnetwork" {
  type        = string
  description = "the subnetwork to host host compute instances"
  default     = "default"
}

variable "startup_script" {
  type        = string
  description = "Name of the startup Script"
  default     = ""
}

variable "backend_protocol" {
  type        = string
  description = "Protocol the backend should be listneing on"
  default     = "https"
}

variable "backend_port" {
  type        = string
  description = "Port the backend should be listneing on"
  default = 443
}

variable "forwarding_port" {
  description = "The IP protocol for the frontend forwarding rule and firewall rule. TCP, UDP, ESP, AH, SCTP or ICMP."
  default     = 443
}

variable "domains" {
  description = "domains for the google managed certificate."
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
  default = {
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    port                = null
    request_path        = null
  }
}

variable "stack" {
  description = "The technology stack to be installed"
  default     = ""
}
variable "envkey" {
  description = "the environment that the stack resides in. Production/Non-Prod"
  default = ""
}

variable "ansible_user" {
  description = "user with rights to run ansible. On Windows, this will also join the server to the domain"
  default     = ""
}

variable "ansible_password" {
  description = "password for the ansible_user account."
  default     = ""
}

variable "admin_groups" {
  description = "Groups to add as sudoers(Linux), Administrators(Windows) Do not use Spaces."
  default     = ""
}

variable "allow_groups" {
  description = "Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces"
  default     = ""
}