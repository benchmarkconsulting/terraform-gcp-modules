locals {
  project = var.project
  region  = var.region
}

provider "google" {
  project = local.project
  region  = local.region
}

### When adding additional modules start your copy here. ###
module "example" {
  source                          = "../"
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