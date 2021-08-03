resource "google_compute_global_forwarding_rule" "default" {
  project               = var.gcp_project
  name                  = "${var.name}-https"
  target                = google_compute_target_https_proxy.https.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.forwarding_port
  ip_address            = var.forwarding_address
  ip_protocol           = var.forwarding_protocol
}

resource "google_compute_target_https_proxy" "https" {
  project          = var.gcp_project
  name             = "${var.name}-https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = google_compute_managed_ssl_certificate.default.*.self_link
}

resource "google_compute_url_map" "default" {
  project         = var.gcp_project
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_health_check" "default" {
  provider            = google-beta
  project             = var.gcp_project
  name                = "${var.name}-hc-${var.backend_protocol}"
  check_interval_sec  = lookup(var.health_check, "check_interval_sec", 5)
  timeout_sec         = lookup(var.health_check, "timeout_sec", 5)
  healthy_threshold   = lookup(var.health_check, "healthy_threshold", 2)
  unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 2)

  log_config {
    enable = var.logging
  }
  dynamic "http_health_check" {
    for_each = var.backend_protocol == "http" ? [{
      request_path = lookup(var.health_check, "request_path", "/")
      port         = lookup(var.health_check, "port", 80)
    }] : []
    iterator = http
    content {
      request_path = lookup(http.value, "request_path", "/")
      port         = lookup(http.value, "port", 80)
    }
  }

  dynamic "https_health_check" {
    for_each = var.backend_protocol == "https" ? [{
      request_path = lookup(var.health_check, "request_path", "/")
      port         = lookup(var.health_check, "port", 443)
    }] : []
    iterator = https
    content {
      request_path = lookup(https.value, "request_path", "/")
      port         = lookup(https.value, "port", 443)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "default" {
  provider         = google-beta
  project          = var.gcp_project
  name             = "${var.name}-backend"
  port_name        = var.backend_protocol
  protocol         = upper(var.backend_protocol)
  health_checks    = google_compute_health_check.default.*.id
  session_affinity = var.session_affinity
  dynamic "backend" {
    for_each = toset(each.value["groups"])
    content {
    group       = lookup(backend.value, "group")
    }
  }
  log_config {
    enable      = true
    sample_rate = "1.0"
  }

  depends_on = [
    google_compute_health_check.default
  ]
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta
  project  = var.gcp_project
  name     = "${var.name}-cert"

  managed {
    domains = var.domains
  }
}