# Terraform MegaPort Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_compute_interconnect_attachment
- Create google_compute_router

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "megaport" {
  source       = "../../terraform-gcp-modules/terraform-gcp-megaport"
  project      = module.shared-services-host-project.project_id
  name         = "megaport"
  region       = "northamerica-northeast1"
  network_name = module.shared-services-host-project.network_name
  description  = "MegaPort Interconnect"
  depends_on   = [module.shared-services-vpc]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The ID of the project ot attach to. | `string` | `""` | yes |
| network_name | Name of the network to attach the interconnect to. | `string` | `""` | yes |
| description | The Description. | `string` | `""` | no |
| name | The prefix of the interconnect and its objects. | `string` | `""` | yes |
| region | The Region in which the interconnect is available. | `string` | `""` | yes |

## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router

## Argument Reference

- router - (Required) URL of the cloud router to be used for dynamic routing. This router must be in the same region as this InterconnectAttachment. The InterconnectAttachment will automatically connect the Interconnect to the network & region within which the Cloud Router is configured.

- name - (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.

- admin_enabled - (Optional) Whether the VLAN attachment is enabled or disabled. When using PARTNER type this will Pre-Activate the interconnect attachment

- interconnect - (Optional) URL of the underlying Interconnect object that this attachment's traffic will traverse through. Required if type is DEDICATED, must not be set if type is PARTNER.

- description - (Optional) An optional description of this resource.

- mtu - (Optional) Maximum Transmission Unit (MTU), in bytes, of packets passing through this interconnect attachment. Currently, only 1440 and 1500 are allowed. If not specified, the value will default to 1440.

- bandwidth - (Optional) Provisioned bandwidth capacity for the interconnect attachment. For attachments of type DEDICATED, the user can set the bandwidth. For attachments of type PARTNER, the Google Partner that is operating the interconnect must set the bandwidth. Output only for PARTNER type, mutable for PARTNER_PROVIDER and DEDICATED, Defaults to BPS_10G Possible values are BPS_50M, BPS_100M, BPS_200M, BPS_300M, BPS_400M, BPS_500M, BPS_1G, BPS_2G, BPS_5G, BPS_10G, BPS_20G, and BPS_50G.

- edge_availability_domain - (Optional) Desired availability domain for the attachment. Only available for type PARTNER, at creation time. For improved reliability, customers should configure a pair of attachments with one per availability domain. The selected availability domain will be provided to the Partner via the pairing key so that the provisioned circuit will lie in the specified domain. If not specified, the value will default to AVAILABILITY_DOMAIN_ANY.

- type - (Optional) The type of InterconnectAttachment you wish to create. Defaults to DEDICATED. Possible values are DEDICATED, PARTNER, and PARTNER_PROVIDER.

- candidate_subnets - (Optional) Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc). Google will attempt to select an unused /29 from the supplied candidate prefix(es). The request will fail if all possible /29s are in use on Google's edge. If not supplied, Google will randomly select an unused /29 from all of link-local space.

- vlan_tag8021q - (Optional) The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094. When using PARTNER type this will be managed upstream.

- region - (Optional) Region where the regional interconnect attachment resides.

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.