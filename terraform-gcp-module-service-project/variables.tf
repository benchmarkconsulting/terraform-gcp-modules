variable "project_id" {
  description = "The ID to give the project. If not provided, the `name` will be used."
  type        = string
  default     = ""
}

variable "name" {
  description = "The name for the project"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "org_id" {
  description = "The ID of the org to host this project"
  type        = string
  default     = ""
}

variable "shared_vpc_subnets" {
  description = "List of subnets fully qualified subnet IDs (ie. projects/$project_id/regions/$region/subnetworks/$subnet_id)"
  type        = list(string)
  default     = []
}

variable "enable_shared_vpc_service_project" {
  description = "If this project should be attached to a shared VPC. If true, you must set shared_vpc variable."
  type        = bool
}

variable "enable_shared_vpc_host_project" {
  description = "If this project is a shared VPC host project. If true, you must *not* set shared_vpc variable. Default is false."
  type        = bool
  default     = false
}

variable "vpc_service_control_attach_enabled" {
  description = "Whether the project will be attached to a VPC Service Control Perimeter"
  type        = bool
  default     = false
}

variable "vpc_service_control_perimeter_name" {
  description = "The name of a VPC Service Control Perimeter to add the created project to"
  type        = string
  default     = null
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}
variable "labels" {
  description = "Map of labels for project"
  type        = map(string)
  default     = {}
}

variable "shared_vpc" {
  type        = string
  description = "Name of the Host VPC."
  default     = ""
}

variable "projects" {
  description = "The project ids to include in this budget. If empty budget will include all projects"
  type        = list(string)
}

variable "amount" {
  description = "The amount to use as the budget"
  type        = number
}

variable "create_budget" {
  description = "If the budget should be created"
  type        = bool
  default     = true
}

variable "display_name" {
  description = "The display name of the budget. If not set defaults to `Budget For <projects[0]|All Projects>` "
  type        = string
  default     = null
}

variable "credit_types_treatment" {
  description = "Specifies how credits should be treated when determining spend for threshold calculations"
  type        = string
  default     = "INCLUDE_ALL_CREDITS"
}

variable "services" {
  description = "A list of services ids to be included in the budget. If omitted, all services will be included in the budget. Service ids can be found at https://cloud.google.com/skus/"
  type        = list(string)
  default     = null
}

variable "alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.7, 1.0]
}

variable "alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`"
  type        = string
  default     = null
}

variable "monitoring_notification_channels" {
  description = "A list of monitoring notification channels in the form `[projects/{project_id}/notificationChannels/{channel_id}]`. A maximum of 5 channels are allowed."
  type        = list(string)
  default     = []
}
