# Terraform Network Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_compute_subnetwork

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "shared-services-vpc" {
  source       = "../../terraform-gcp-modules/terraform-gcp-network"
  project_id   = module.shared-services-host-project.project_id
  network_name = module.shared-services-host-project.network_name
  depends_on   = [module.shared-services-host-project]
  subnets = [
    {
      subnet_name   = "cloudcoreprod"
      subnet_ip     = "10.30.0.0/24"
      subnet_region = "northamerica-northeast1"
    },
      ]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| firewall\_rules | List of firewall rules | `any` | `[]` | no |
| mtu | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically. | `number` | `0` | no |
| network\_name | The name of the network being created | `any` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `any` | n/a | yes |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |
| subnets | The list of subnets being created | `list(map(string))` | n/a | yes |

### Subnet Inputs

The subnets list contains maps, where each object represents a subnet. Each map has the following inputs (please see examples folder for additional references):

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet\_name | The name of the subnet being created  | string | - | yes |
| subnet\_ip | The IP and CIDR range of the subnet being created | string | - | yes |
| subnet\_region | The region where the subnet will be created  | string | - | yes |
| subnet\_private\_access | Whether this subnet will have private Google access enabled | string | `"false"` | no |
| subnet\_flow\_logs  | Whether the subnet will record and send flow log data to logging | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| network | The created network |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | VPC project id |
| route\_names | The route names associated with this VPC |
| subnets | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets. |
| subnets\_flow\_logs | Whether the subnets will have VPC flow logs enabled |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets will have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |

## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

## Argument Reference

- name - (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.
description - (Optional) An optional description of this resource. The resource must be recreated to modify this field.

- auto_create_subnetworks - (Optional) When set to true, the network is created in "auto subnet mode" and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in "custom subnet mode" so the user can explicitly connect subnetwork resources.

- routing_mode - (Optional) The network-wide routing mode to use. If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with all subnetworks of this network, across regions. Possible values are REGIONAL and GLOBAL.

- mtu - (Optional) Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes.

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- delete_default_routes_on_create - (Optional) If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false.