# Terraform Postgres Module

This module handles Google CloudSQL creation in gcp


## Compatibility

This module is meant for use with Terraform 0.14.

## Permissions

- Cloud SQL Admin: roles/cloudsql.admin

## Usage

```hcl
locals {
  project = var.project
  region  = var.region
}

provider "google" {
  project = local.project
  region  = local.region
}

module "example" {
  source                          = "../../../modules-gcp/module-postgres"
  project                         = local.project
  region                          = var.region
  zone                            = var.zone
  name                            = var.name
  db_name                         = var.db_name
  tier                            = var.tier
  availability_type               = var.availability_type
  random_instance_name            = var.random_instance_name
  deletion_protection             = var.deletion_protection
  enable_default_db               = var.enable_default_db
  enable_default_user             = var.enable_default_user
  user_name                       = var.user_name
  user_password                   = var.user_password
  disk_autoresize                 = var.disk_autoresize
  disk_size                       = var.disk_size
  disk_type                       = var.disk_type
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track
  backup_configuration            = var.backup_configuration
  ip_configuration                = var.ip_configuration
  insights_config                 = var.insights_config
  additional_users                = var.additional_users
  user_labels                     = var.user_labels
  additional_databases            = var.additional_databases
}

```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster | <pre>list(object({<br>    name     = string<br>    password = string<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"REGIONAL"` | no |
| backup\_configuration | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = string<br>    location                       = string<br>    point_in_time_recovery_enabled = bool<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "location": null,<br>  "point_in_time_recovery_enabled": false,<br>  "start_time": null<br>}</pre> | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | `string` | `"25m"` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | The database version to use | `string` | "POSTGRES_13" | yes |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | `string` | `"2h"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_size | The disk size for the master instance. | `number` | `10` | no |
| disk\_type | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| enable\_default\_db | Enable or disable the creation of the default database | `bool` | `true` | no |
| enable\_default\_user | Enable or disable the creation of the default user | `bool` | `true` | no |
| insights\_config | The insights\_config settings for the database. | <pre>object({<br>    query_string_length     = number<br>    record_application_tags = bool<br>    record_client_address   = bool<br>  })</pre> | `null` | no |
| ip\_configuration | The ip configuration for the master instances. | <pre>object({<br>    authorized_networks = list(map(string))<br>    ipv4_enabled        = bool<br>    private_network     = string<br>    require_ssl         = bool<br>  })</pre> | <pre>{<br>  "authorized_networks": [],<br>  "ipv4_enabled": true,<br>  "private_network": null,<br>  "require_ssl": null<br>}</pre> | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL master instance | `string` | n/a | yes |
| project | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| region | The region of the Cloud SQL resources | `string` | `"northamerica-northeast1"` | no |
| tier | The tier for the master instance. | `string` | `"db-f1-micro"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | `string` | `"25m"` | no |
| user\_labels | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the master instance, it should be something like: `northamerica-northeast1-a`, `us-east1-c`. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_ip\_address | The IPv4 address assigned for the master instance |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| instances | A list of all `google_sql_database_instance` resources we've created |
| primary | The `google_sql_database_instance` resource representing the primary instance |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |



## Info

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance