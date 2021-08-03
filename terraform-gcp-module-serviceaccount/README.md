# Terraform Service Account Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_service_account

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "veem-service-account" {
  source     = "../../terraform-gcp-modules/terraform-gcp-serviceaccount"
  project_id = module.backupprod-project.project_id
  prefix     = "veeam"
  description = "Service account for Veeam Backups"
  names         = ["sa"]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Default description of the created service accounts (defaults to no description) | `string` | `""` | no |
| display\_name | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `"Terraform-managed service account"` | no |
| generate\_keys | Generate keys for service accounts. | `bool` | `false` | no |
| names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| org\_id | Id of the organization for org-level roles. | `string` | `""` | no |
| prefix | Prefix applied to service account names. | `string` | `""` | no |
| project\_id | Project id where service account will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_email | IAM-format service account email (for single use). |
| iam\_emails | IAM-format service account emails by name. |
| service\_account | Service account resource (for single use). |
| service\_accounts | Service account resources as list. |

## Info 

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account

## Argument Reference

- account_id - (Required) The account id that is used to generate the service account email address and a stable unique id. It is unique within a project, must be 6-30 characters long, and match the regular expression [a-z]([-a-z0-9]*[a-z0-9]) to comply with RFC1035. Changing this forces a new service account to be created.

- display_name - (Optional) The display name for the service account. Can be updated without creating a new resource.

- description - (Optional) A text description of the service account. Must be less than or equal to 256 UTF-8 bytes.

- project - (Optional) The ID of the project that the service account will be created in. Defaults to the provider project configuration.