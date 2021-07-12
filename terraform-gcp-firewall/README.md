# Terraform network firewall Module

This module handles firewall rule creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create firewall rules

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform
0.11.x-compatible version of this module, the last released version
intended for Terraform 0.11.x is [3.0.0].

## Usage

```hcl
module "firewall" {
    source = "git::https://github.com/benchmarkconsulting/gcp-terraform-modules//firewall"

    firewall = [
        {
            name                 = "ssh"
            network              = module.vpc.network_name
            protocol             = "tcp"
            ports                = "22"
            source_ranges        = "0.0.0.0/0"
            source_tags          = "ssh"
            target_tags          = "ssh"
        },
        {
            name                 = "http"
            network              = module.vpc.network_name
            protocol             = "tcp"
            ports                = "80"
            source_ranges        = "0.0.0.0/0"
            source_tags          = "http"
            target_tags          = "http"
        },
    ]
} 
```
