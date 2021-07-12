variable "vmname" {
  description = "The name of the virtual machine used to deploy the vms."
  default     = "terraformvm"
}

variable "vmnamesuffix" {
  description = "vmname suffix after numbered index coming from instance variable."
  default     = ""
}

variable "vmnameliteral" {
  description = "vmname without any suffix or Prefix, only to be used for single instances."
  default     = ""
}

variable "instances_count" {
  description = "number of instances you want deploy from the template."
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "GCP compute type."
  default     = "n1-standard-1"
}

variable "zone" {
  type        = string
  description = "Zone ot deploy the machine in"
  default     = "us-east1-b"
}

variable "image" {
  type        = string
  description = "OS image to use for compute instance"
  default     = "ubuntu-1904-disco-v20191019"
}

variable "subnetwork" {
  type        = string
  description = "the subnetwork to host host compute instances"
  default     = "default"
}

variable "subnetwork_project" {
  type        = string
  description = "The project in which the subnetwork belongs."
  default     = ""
}

variable "tags" {
  type        = list(string)
  description = "any tags you want to add to the image"
}

variable "startup-script" {
  type        = string
  description = "Name of the startup Script"
  default     = ""
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

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}

variable "pub_ssh" {
  description = "Public SSH Key added to instance."
  default     = ""
}

variable "startup" {
  description = "Startup script to install dependencies and configure AD"
  default     = ""
}

variable "labels" {
  default     = null
}

variable "access_config" {
  description = "IPs the VM instance can be accessed via the Internet. If empty google will auto assign"
  type = list(object({
    nat_ip       = string
  }))
  default = []
}