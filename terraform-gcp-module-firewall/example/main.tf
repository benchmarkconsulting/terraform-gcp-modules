// /******************************************
//   Firewall Rules
//  *****************************************/
locals {
  firewall_rules = {
    external-deny-internet = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = null
      sources              = null
      rules = [{
        protocol = "tcp"
        ports    = null
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    internal-allow-icmp = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.30.0.0/15"]
      use_service_accounts = false
      targets              = null
      sources              = null
      rules = [{
        protocol = "icmp"
        ports    = null
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    core-allow = {
      description          = "allow core services ports"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.30.0.0/15"]
      use_service_accounts = false
      targets              = null
      sources              = null
      rules = [{
        protocol = "tcp"
        ports    = ["53", "88", "123", "389", "464"]
        },
        {
          protocol = "udp"
          ports    = ["53", "88", "123", "389", "464"]
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-ssh = {
      description          = "allow SSH"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.30.0.0/15"] # source or destination ranges (depends on `direction`)
      use_service_accounts = false            # if `true` targets/sources expect list of instances SA, if false - list of tags
      targets              = ["ssh"]          # target_service_accounts or target_tags depends on `use_service_accounts` value
      sources              = ["ssh"]          # source_service_accounts or source_tags depends on `use_service_accounts` value
      rules = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-rdp = {
      description          = "allow RDP"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.30.0.0/15"] # source or destination ranges (depends on `direction`)
      use_service_accounts = false            # if `true` targets/sources expect list of instances SA, if false - list of tags
      targets              = ["rdp"]          # target_service_accounts or target_tags depends on `use_service_accounts` value
      sources              = ["rdp"]          # source_service_accounts or source_tags depends on `use_service_accounts` value
      rules = [{
        protocol = "tcp"
        ports    = ["3389"]
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    // Example how to allow connection from instances with `backend` tag, to instances with `databases` tag
    allow-http = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["http"] # target_tags
      sources              = ["http"] # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
    allow-https = {
      description          = "Allow backend nodes connection to databases instances"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["https"] # target_tags
      sources              = ["https"] # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["443"]
      }]
      extra_attributes = {
        disabled           = false
        priority           = 95
        flow_logs          = true
        flow_logs_metadata = "EXCLUDE_ALL_METADATA"
      }
    }
  }
}
module "firewall_rules" {
  source                  = "../../../modules-gcp/module-firewall"
  project_id              = module.shared-services-host-project.project_id
  network                 = module.shared-services-host-project.network_name
  internal_ranges_enabled = false
  depends_on              = [module.shared-services-host-project]
  custom_rules            = local.firewall_rules
}