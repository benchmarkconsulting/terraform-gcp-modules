# Terraform Firewall Module

This module handles firewall rule creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_compute_firewall

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
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
  }
}
module "firewall_rules" {
  source                  = "../../terraform-gcp-modules/terraform-gcp-firewall"
  project_id              = module.shared-services-host-project.project_id
  network                 = module.shared-services-host-project.network_name
  internal_ranges_enabled = false
  depends_on              = [module.shared-services-host-project]
  custom_rules            = local.firewall_rules
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | Name of the network this set of firewall rules applies to. | `any` | n/a | yes |
| project\_id | Project id of the project that holds the network. | `any` | n/a | yes |
| rules | List of custom rule definitions (refer to variables file for syntax). | <pre>list(object({<br>    name                    = string<br>    description             = string<br>    direction               = string<br>    priority                = number<br>    ranges                  = list(string)<br>    source_tags             = list(string)<br>    source_service_accounts = list(string)<br>    target_tags             = list(string)<br>    target_service_accounts = list(string)<br>    allow = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    deny = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    log_config = object({<br>      metadata = string<br>    })<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| firewall\_rules | The created firewall rule resources |

## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

## Argument Reference

- name - (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.

- network - (Required) The name or self_link of the network to attach this firewall to.

- allow - (Optional) The list of ALLOW rules specified by this firewall. Each rule specifies a protocol and port-range tuple that describes a permitted connection. Structure is documented below.

- deny - (Optional) The list of DENY rules specified by this firewall. Each rule specifies a protocol and port-range tuple that describes a denied connection. Structure is documented below.

- description - (Optional) An optional description of this resource. Provide this property when you create the resource.

- destination_ranges - (Optional) If destination ranges are specified, the firewall will apply only to traffic that has destination IP address in these ranges. These ranges must be expressed in CIDR format. Only IPv4 is supported.

- direction - (Optional) Direction of traffic to which this firewall applies; default is INGRESS. Note: For INGRESS traffic, it is NOT supported to specify destinationRanges; For EGRESS traffic, it is NOT supported to specify sourceRanges OR sourceTags. Possible values are INGRESS and EGRESS.

- disabled - (Optional) Denotes whether the firewall rule is disabled, i.e not applied to the network it is associated with. When set to true, the firewall rule is not enforced and the network behaves as if it did not exist. If this is unspecified, the firewall rule will be enabled.

- log_config - (Optional) This field denotes the logging options for a particular firewall rule. If defined, logging is enabled, and logs will be exported to Cloud Logging. Structure is documented below.

- priority - (Optional) Priority for this rule. This is an integer between 0 and 65535, both inclusive. When not specified, the value assumed is 1000. Relative priorities determine precedence of conflicting rules. Lower value of priority implies higher precedence (eg, a rule with priority 0 has higher precedence than a rule with priority 1). DENY rules take precedence over ALLOW rules having equal priority.

- source_ranges - (Optional) If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply. Only IPv4 is supported.

- source_service_accounts - (Optional) If source service accounts are specified, the firewall will apply only to traffic originating from an instance with a service account in this list. Source service accounts cannot be used to control traffic to an instance's external IP address because service accounts are associated with an instance, not an IP address. sourceRanges can be set at the same time as sourceServiceAccounts. If both are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP belongs to an instance with service account listed in sourceServiceAccount. The connection does not need to match both properties for the firewall to apply. sourceServiceAccounts cannot be used at the same time as sourceTags or targetTags.

- source_tags - (Optional) If source tags are specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address. Because tags are associated with an instance, not an IP address. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply.

- target_service_accounts - (Optional) A list of service accounts indicating sets of instances located in the network that may make network connections as specified in allowed[]. targetServiceAccounts cannot be used at the same time as targetTags or sourceTags. If neither targetServiceAccounts nor targetTags are specified, the firewall rule applies to all instances on the specified network.

- target_tags - (Optional) A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. If no targetTags are specified, the firewall rule applies to all instances on the specified network.

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- enable_logging - (Optional, Deprecated) This field denotes whether to enable logging for a particular firewall rule. If logging is enabled, logs will be exported to Stackdriver. Deprecated in favor of log_config

The allow block supports:

- protocol - (Required) The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp, ipip, all), or the IP protocol number.

- ports - (Optional) An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ["22"], ["80","443"], and ["12345-12349"].

The deny block supports:

- protocol - (Required) The IP protocol to which this rule applies. The protocol type is required when creating a firewall rule. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp, ipip, all), or the IP protocol number.

- ports - (Optional) An optional list of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. Each entry must be either an integer or a range. If not specified, this rule applies to connections through any port. Example inputs include: ["22"], ["80","443"], and ["12345-12349"].

The log_config block supports:

- metadata - (Required) This field denotes whether to include or exclude metadata for firewall logs. Possible values are EXCLUDE_ALL_METADATA and INCLUDE_ALL_METADATA.