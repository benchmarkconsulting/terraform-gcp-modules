stack                   = "base_win"
project                 = "sandbox-279017"
region                  = "northamerica-northeast1"
zone                    = ""
machine_type            = ""
instances_count         = 2
vm_name                 = ""
image                   = ""
is_windows_image        = false
tags                    = [""]
startup_script          = ""
disk_size_gb            = 60
data_disk_size_gb       = [100]
backend_protocol        = "https"
backend_port            = 443
forwarding_port         = 443
domains                 = [""]
health_check = {
    check_interval_sec  = 8
    timeout_sec         = 8
    healthy_threshold   = 4
    unhealthy_threshold = 4
    request_path        = "/yoururl"
    port                = 443
  }
envkey                  = "Production"
ansible_user            = "ansible_user"
ansible_password        = ""
#Groups to add as sudoers(Linux) or Administrators(Windows). Sudoers will also be added to the allow gourps automatially. Do not use Spaces
#At least one group must exist for Linux machines or SSSD will fail and machine will need to be destoryed.
admin_groups            = ""
#Groups to add as allowgroups(Linux), Remote desktop users(Windows). Do not use Spaces
allow_groups            = ""