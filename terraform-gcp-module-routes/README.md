# Terraform Routes Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_compute_route

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
 module "routes" {
   source       = "../../terraform-gcp-modules/terraform-gcp-routes"
   project_id   = module.shared-services-host-project.project_id
   network_name = module.shared-services-host-project.network_name
   routes = [
     {
       name              = "egress-internet"
       description       = "route through IGW to access internet"
       destination_range = "0.0.0.0/0"
       tags              = "egress-inet"
       next_hop_internet = "true"
     },
   ]
 }
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| network\_name | The name of the network where routes will be created | `any` | n/a | yes |
| project\_id | The ID of the project where the routes will be created | `any` | n/a | yes |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| routes | The created routes resources |


## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route


## Argument Reference

- dest_range - (Required) The destination range of outgoing packets that this route applies to. Only IPv4 is supported.

- name - (Required) Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.

- network - (Required) The network that this route applies to.

- description - (Optional) An optional description of this resource. Provide this property when you create the resource.

- priority - (Optional) The priority of this route. Priority is used to break ties in cases where there is more than one matching route of equal prefix length. In the case of two routes with equal prefix length, the one with the lowest-numbered priority value wins. Default value is 1000. Valid range is 0 through 65535.

- tags - (Optional) A list of instance tags to which this route applies.

- next_hop_gateway - (Optional) URL to a gateway that should handle matching packets. Currently, you can only specify the internet gateway, using a full or partial valid URL:

https://www.googleapis.com/compute/v1/projects/project/global/gateways/default-internet-gateway
projects/project/global/gateways/default-internet-gateway
global/gateways/default-internet-gateway
The string default-internet-gateway.
next_hop_instance - (Optional) URL to an instance that should handle matching packets. You can specify this as a full or partial URL. For example:

https://www.googleapis.com/compute/v1/projects/project/zones/zone/instances/instance
projects/project/zones/zone/instances/instance
zones/zone/instances/instance
Just the instance name, with the zone in next_hop_instance_zone.
next_hop_ip - (Optional) Network IP address of an instance that should handle matching packets.

- next_hop_vpn_tunnel - (Optional) URL to a VpnTunnel that should handle matching packets.

- next_hop_ilb - (Optional) The URL to a forwarding rule of type loadBalancingScheme=INTERNAL that should handle matching packets. You can only specify the forwarding rule as a partial or full URL. For example, the following are all valid URLs: https://www.googleapis.com/compute/v1/projects/project/regions/region/forwardingRules/forwardingRule regions/region/forwardingRules/forwardingRule Note that this can only be used when the destinationRange is a public (non-RFC 1918) IP CIDR range.

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- next_hop_instance_zone - (Optional when next_hop_instance is specified) The zone of the instance specified in next_hop_instance. Omit if next_hop_instance is specified as a URL.