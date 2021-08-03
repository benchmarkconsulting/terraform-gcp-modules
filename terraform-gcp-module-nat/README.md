# Terraform NAT Module

This module handles NAT and Router creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_compute_router
- Create google_compute_router_nat

## Compatibility

This module is meant for use with Terraform 0.14.


## Usage

```hcl
module "nat" {
  source                 = "../../terraform-gcp-modules/terraform-gcp-nat"
  project_id             = module.shared-services-host-project.project_id
  region                 = "northamerica-northeast1"
  network                = module.shared-services-host-project.network_name
  router_name            = "nat-router-01"
  nat_name               = "nat-01"
  network_name           = module.shared-services-host-project.network_name
  nat_ip_allocate_option = "AUTO_ONLY"
  depends_on             = [module.shared-services-vpc]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_router | Create router instead of using an existing one, uses 'router' variable for new resource name. | `bool` | `false` | no |
| enable\_endpoint\_independent\_mapping | Specifies if endpoint independent mapping is enabled. | `bool` | `null` | no |
| icmp\_idle\_timeout\_sec | Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |
| log\_config\_enable | Indicates whether or not to export logs | `bool` | `false` | no |
| log\_config\_filter | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL" | `string` | `"ALL"` | no |
| min\_ports\_per\_vm | Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created. | `string` | `"64"` | no |
| name | Defaults to 'cloud-nat-RANDOM\_SUFFIX'. Changing this forces a new NAT to be created. | `string` | `""` | no |
| nat\_ip\_allocate\_option | Value inferred based on nat\_ips. If present set to MANUAL\_ONLY, otherwise AUTO\_ONLY. | `string` | `"false"` | no |
| nat\_ips | List of self\_links of external IPs. Changing this forces a new NAT to be created. | `list(string)` | `[]` | no |
| network | VPN name, only if router is not passed in and is created by the module. | `string` | `""` | no |
| project\_id | The project ID to deploy to | `any` | n/a | yes |
| region | The region to deploy to | `any` | n/a | yes |
| router | The name of the router in which this NAT will be configured. Changing this forces a new NAT to be created. | `any` | n/a | yes |
| router\_asn | Router ASN, only if router is not passed in and is created by the module. | `string` | `"64514"` | no |
| source\_subnetwork\_ip\_ranges\_to\_nat | Defaults to ALL\_SUBNETWORKS\_ALL\_IP\_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. Changing this forces a new NAT to be created. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| subnetworks | n/a | <pre>list(object({<br>    name                     = string,<br>    source_ip_ranges_to_nat  = list(string)<br>    secondary_ip_range_names = list(string)<br>  }))</pre> | `[]` | no |
| tcp\_established\_idle\_timeout\_sec | Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created. | `string` | `"1200"` | no |
| tcp\_transitory\_idle\_timeout\_sec | Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |
| udp\_idle\_timeout\_sec | Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created. | `string` | `"30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Name of the Cloud NAT |
| nat\_ip\_allocate\_option | NAT IP allocation mode |
| region | Cloud NAT region |
| router\_name | Cloud NAT router name |



## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat

## Argument Reference

- name - (Required) Name of the NAT service. The name must be 1-63 characters long and comply with RFC1035.

- nat_ip_allocate_option - (Required) How external IPs should be allocated for this NAT. Valid values are AUTO_ONLY for only allowing NAT IPs allocated by Google Cloud Platform, or MANUAL_ONLY for only user-allocated NAT IP addresses. Possible values are MANUAL_ONLY and AUTO_ONLY.

- source_subnetwork_ip_ranges_to_nat - (Required) How NAT should be configured per Subnetwork. If ALL_SUBNETWORKS_ALL_IP_RANGES, all of the IP ranges in every Subnetwork are allowed to Nat. If ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, all of the primary IP ranges in every Subnetwork are allowed to Nat. LIST_OF_SUBNETWORKS: A list of Subnetworks are allowed to Nat (specified in the field subnetwork below). Note that if this field contains ALL_SUBNETWORKS_ALL_IP_RANGES or ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, then there should not be any other RouterNat section in any Router for this network in this region. Possible values are ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, and LIST_OF_SUBNETWORKS.

- router - (Required) The name of the Cloud Router in which this NAT will be configured.

- nat_ips - (Optional) Self-links of NAT IPs. Only valid if natIpAllocateOption is set to MANUAL_ONLY.

- drain_nat_ips - (Optional) A list of URLs of the IP resources to be drained. These IPs must be valid static external IPs that have been assigned to the NAT.

- subnetwork - (Optional) One or more subnetwork NAT configurations. Only used if source_subnetwork_ip_ranges_to_nat is set to LIST_OF_SUBNETWORKS Structure is documented below.

- min_ports_per_vm - (Optional) Minimum number of ports allocated to a VM from this NAT.

- udp_idle_timeout_sec - (Optional) Timeout (in seconds) for UDP connections. Defaults to 30s if not set.

- icmp_idle_timeout_sec - (Optional) Timeout (in seconds) for ICMP connections. Defaults to 30s if not set.

- tcp_established_idle_timeout_sec - (Optional) Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set.

- tcp_transitory_idle_timeout_sec - (Optional) Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set.

- log_config - (Optional) Configuration for logging on NAT Structure is documented below.

- enable_endpoint_independent_mapping - (Optional) Specifies if endpoint independent mapping is enabled. This is enabled by default. For more information see the official documentation.

- region - (Optional) Region where the router and NAT reside.

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

The subnetwork block supports:

- name - (Required) Self-link of subnetwork to NAT

- source_ip_ranges_to_nat - (Required) List of options for which source IPs in the subnetwork should have NAT enabled. Supported values include: ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.

- secondary_ip_range_names - (Optional) List of the secondary ranges of the subnetwork that are allowed to use NAT. This can be populated only if LIST_OF_SECONDARY_IP_RANGES is one of the values in sourceIpRangesToNat

The log_config block supports:

- enable - (Required) Indicates whether or not to export logs.

- filter - (Required) Specifies the desired filtering of logs on this NAT. Possible values are ERRORS_ONLY, TRANSLATIONS_ONLY, and ALL.
