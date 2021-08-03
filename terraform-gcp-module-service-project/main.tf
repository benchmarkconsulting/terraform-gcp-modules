/******************************************
  Project random id suffix configuration
 *****************************************/
resource "random_id" "random_project_id_suffix" {
  byte_length = 2
}
locals {
  base_project_id = var.name
  temp_project_id = format(
    "%s-%s",
    local.base_project_id,
    random_id.random_project_id_suffix.hex,
  )
}
/*******************************************
  Project creation
 *******************************************/
resource "google_project" "svcproject" {
  name                = var.name
  project_id          = local.temp_project_id
  folder_id           = var.folder_id
  org_id              = var.org_id
  billing_account     = var.billing_account
  auto_create_network = false
  labels              = var.labels
}


/******************************************
  Shared VPC attachment
 *****************************************/
resource "google_compute_shared_vpc_service_project" "shared_vpc_attachment" {
  provider        = google-beta
  count           = var.enable_shared_vpc_service_project ? 1 : 0
  host_project    = var.shared_vpc
  service_project = google_project.svcproject.project_id
  depends_on      = [google_project.svcproject]
}

/******************************************
  Budget
 *****************************************/

locals {
  project_name     = length(var.projects) == 0 ? "All Projects" : var.projects[0]
  display_name     = var.display_name == null ? "Budget For ${local.project_name}" : var.display_name
  all_updates_rule = var.alert_pubsub_topic == null && length(var.monitoring_notification_channels) == 0 ? [] : ["1"]

  projects = length(var.projects) == 0 ? null : [
    for project in data.google_project.project :
    "projects/${project.number}"
  ]
  services = var.services == null ? null : [
    for id in var.services :
    "services/${id}"
  ]
}

data "google_project" "project" {
  depends_on = [var.projects]
  count      = length(var.projects)
  project_id = element(var.projects, count.index)
}

resource "google_billing_budget" "budget" {
  provider = google-beta
  count    = var.create_budget ? 1 : 0

  billing_account = var.billing_account
  display_name    = local.display_name

  budget_filter {
    projects               = local.projects
    credit_types_treatment = var.credit_types_treatment
    services               = local.services
  }

  amount {
    specified_amount {
      units = tostring(var.amount)
    }
  }

  dynamic "threshold_rules" {
    for_each = var.alert_spent_percents
    content {
      threshold_percent = threshold_rules.value
    }
  }

  dynamic "all_updates_rule" {
    for_each = local.all_updates_rule
    content {
      pubsub_topic                     = var.alert_pubsub_topic
      monitoring_notification_channels = var.monitoring_notification_channels
    }
  }
}
