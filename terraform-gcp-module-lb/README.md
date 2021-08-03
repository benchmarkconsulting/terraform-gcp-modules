# Terraform Load Balancer Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create Compute Instances
- Requires start up script in /scripts/var.script-name in your terraform root

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
mmodule "compute" {
    source = "git::https://github.com/benchmarkconsulting/gcp-terraform-modules//compute"
    amount = 1
    name_prefix  = "compute"
    tags = "ssh"
    machine_type = "n1-standard-1"
    zone         = "us-east1-b"
    image        = "ubuntu-1904-disco-v20191020"
    subnetwork   = "subnet-01"
    startup-script = "bootstrap.txt"
}

```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| all\_folder\_admins | List of IAM-style members that will get the extended permissions across all the folders. | `list(string)` | `[]` | no |
| folder\_admin\_roles | List of roles that will be applied to per folder owners on their respective folder. | `list(string)` | <pre>[<br>  "roles/owner",<br>  "roles/resourcemanager.folderViewer",<br>  "roles/resourcemanager.projectCreator",<br>  "roles/compute.networkAdmin"<br>]</pre> | no |
| names | Folder names. | `list(string)` | `[]` | no |
| parent | The resource name of the parent Folder or Organization. Must be of the form folders/folder\_id or organizations/org\_id | `string` | n/a | yes |
| per\_folder\_admins | IAM-style members per folder who will get extended permissions. | `map(string)` | `{}` | no |
| prefix | Optional prefix to enforce uniqueness of folder names. | `string` | `""` | no |
| set\_roles | Enable setting roles via the folder admin variables. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| folder | Folder resource (for single use). |
| folders | Folder resources as list. |
| folders\_map | Folder resources by name. |
| id | Folder id (for single use). |
| ids | Folder ids. |
| ids\_list | List of folder ids. |
| name | Folder name (for single use). |
| names | Folder names. |
| names\_list | List of folder names. |

## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule