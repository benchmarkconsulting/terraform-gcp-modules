# Terraform NAT Module

This module handles NAT and Router creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create Router
- Create NAT 

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform
0.11.x-compatible version of this module, the last released version
intended for Terraform 0.11.x is [3.0.0].

## Usage

```hcl
module "nat" {
    source = "git::https://github.com/benchmarkconsulting/gcp-terraform-modules//nat"
    router_name = "router-01"
    nat_name = "nat-01"
    network_name = module.vpc.network_name
}
```
