project                         = "sandbox-279017"
region                          = "northamerica-northeast1"
zone                            = "northamerica-northeast1-a"
name                            = "tst-postgres"
enable_default_db               = true
db_name                         = "1stDB"
tier                            = "db-f1-micro"
availability_type               = "REGIONAL"
random_instance_name            = true
deletion_protection             = false
enable_default_user             = false
user_name                       = "default_user"
user_password                   = "default_pass"
disk_autoresize                 = true
disk_size                       = 10
disk_type                       = "PD_SSD"
maintenance_window_day          = 2
maintenance_window_hour         = 15
maintenance_window_update_track = "canary"
backup_configuration = {
  enabled                        = true
  start_time                     = "21:00"
  location                       = "northamerica-northeast1"
  point_in_time_recovery_enabled = false
}

ip_configuration = {
  ipv4_enabled = true
  require_ssl  = true
  authorized_networks = [
    {
      name  = "sharedservices",
      value = "199.27.25.0/24"
    },
    {
      name  = "flexg3prod",
      value = "199.27.30.0/24"
    }
  ]
}

insights_config = {
  query_insights_enabled  = true
  query_string_length     = 1024
  record_application_tags = false
  record_client_address   = false
}

additional_users = [
  {
    name     = "user1",
    password = "user199*"
  },
  {
    name     = "user2",
    password = "user299*"
  }
]

user_labels = {
  database = "postgres"
  state    = "active"
}


additional_databases = [
  {
    name      = "additional_databases1"
    charset   = "UTF8"
    collation = "en_US.UTF8"
  }
]