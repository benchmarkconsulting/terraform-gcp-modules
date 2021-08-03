data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

resource "google_compute_instance_group" "uig" {
  name        = "${var.name}-uig"
  project             = var.gcp_project
  description = "${var.name} instance group in ${var.zone}"
  instances = var.instances_group
  dynamic "named_port" {
    for_each = var.backend_protocol == "http" ? [{
      name = var.backend_protocol
      port = var.backend_port
    }] : []
    iterator = http
    content {
      name = lookup(http.value, "name", "http")
      port = lookup(http.value, "port", 8080)
    } 
  }
  dynamic "named_port" {
    for_each = var.backend_protocol == "https" ? [{
      name = var.backend_protocol
      port = var.backend_port
    }] : []
    iterator = https
    content {
      name = lookup(https.value, "name", "https")
      port = lookup(https.value, "port", 447)
    } 
  }
}

