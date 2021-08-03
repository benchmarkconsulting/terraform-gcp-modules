# Terraform Folders Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_folder
- Create google_folder_iam_binding

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "top-level" {
  source = "../../terraform-gcp-modules/terraform-gcp-folders"
  parent = "organizations/370753128095"
  names = [
    "CloudCore",
  ]
  set_roles = true
  all_folder_admins = [
    "group:gcp-organization-admins@univeris.com",
  ]
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

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_folder

## Argument Reference

- display_name - (Required) The folder’s display name. A folder’s display name must be unique amongst its siblings, e.g. no two folders with the same parent can share the same display name. The display name must start and end with a letter or digit, may contain letters, digits, spaces, hyphens and underscores and can be no longer than 30 characters.

- parent - (Required) The resource name of the parent Folder or Organization. Must be of the form folders/{folder_id} or organizations/{org_id}.
