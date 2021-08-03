# Terraform Shared VPC Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_project
- Create google_compute_shared_vpc_host_project

## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "shared-services-host-project" {
  source                            = "../../terraform-gcp-modules/terraform-gcp-sharedvpc"
  project_id                        = module.shared-services-host-project.project_id
  name                              = "foundation"
  org_id                            = "370753128095"
  billing_account                   = "0193C6-E56AA8-81B0DB"
  enable_shared_vpc_host_project    = true
  enable_shared_vpc_service_project = false
  network_name                      = "foundation-network"
  description                       = "Shared Services Network"
  depends_on                        = [module.it-folders]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|

| auto\_create\_network | Create the default network | `bool` | `false` | no |
| billing\_account | The ID of the billing account to associate this project with | `string` | n/a | yes |
| budget\_alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` | `string` | `null` | no |
| budget\_alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded | `list(number)` | <pre>[<br>  0.5,<br>  0.7,<br>  1<br>]</pre> | no |
| budget\_amount | The amount to use for a budget alert | `number` | `null` | no |
| budget\_monitoring\_notification\_channels | A list of monitoring notification channels in the form `[projects/{project_id}/notificationChannels/{channel_id}]`. A maximum of 5 channels are allowed. | `list(string)` | `[]` | no |
| folder\_id | The ID of a folder to host this project | `string` | `""` | no |
| labels | Map of labels for project | `map(string)` | `{}` | no |
| name | The name for the project | `string` | n/a | yes |
| org\_id | The organization ID. | `string` | n/a | yes |
| project\_id | The ID to give the project. If not provided, the `name` will be used. | `string` | `""` | no |
| shared\_vpc | The ID of the host project which hosts the shared VPC | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | If provided, the project uses the given project ID. Mutually exclusive with random\_project\_id being true. |
| project\_name | The name for the project |
| project\_number | The number for the project |


## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_host_project

## Argument Reference

- name - (Required) The display name of the project.

- project_id - (Required) The project ID. Changing this forces a new project to be created.

- org_id - (Optional) The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of org_id or folder_id may be specified. If the org_id is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization.

- folder_id - (Optional) The numeric ID of the folder this project should be created under. Only one of org_id or folder_id may be specified. If the folder_id is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder.

- billing_account - (Optional) The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have at mininum Billing Account User privileges (roles/billing.user) on the billing account. See Google Cloud Billing API Access Control for more details.

- skip_delete - (Optional) If true, the Terraform resource can be deleted without deleting the Project via the Google API.

- labels - (Optional) A set of key/value label pairs to assign to the project.

- auto_create_network - (Optional) Create the 'default' network automatically. Default true. If set to false, the default network will be deleted. Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set auto_create_network to false, since the network will exist momentarily.

- host_project - (Required) The ID of a host project to associate.

- service_project - (Required) The ID of the project that will serve as a Shared VPC service project.