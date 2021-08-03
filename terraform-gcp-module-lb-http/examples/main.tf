locals {
  name = var.vm_name
  project = var.project
  region  = var.region
}

provider "google" {
  project = local.project
  region  = local.region
}
provider "google-beta" {
  project = local.project
  region  = local.region
}

terraform {
  backend "gcs" {
    bucket = "test-lb"
    prefix = "terraform/test/loadbalancercom"
  }
}

module "example" {
  source              = "../terraform-gcp-modules/terraform-gcp-compute"
  instances_count     = 1
  vmname              = local.name
  machine_type        = var.machine_type
  image               = var.image
  is_windows_image    = var.is_windows_image
  zone                = var.zone
  tags                = var.tags
  disk_size_gb        = var.disk_size_gb
  data_disk_size_gb   = var.data_disk_size_gb
  subnetwork          = var.subnetwork
  startup-script      = var.startup_script
}

module "example2" {
  source              = "../terraform-gcp-modules/terraform-gcp-compute"
  instances_count     = 1
  vmname              = local.name
  machine_type        = var.machine_type
  image               = var.image
  is_windows_image    = var.is_windows_image
  zone                = var.zone
  tags                = var.tags
  disk_size_gb        = var.disk_size_gb
  data_disk_size_gb   = var.data_disk_size_gb
  subnetwork          = var.subnetwork
  startup-script      = var.startup_script
}


module "load_balancer" {
  source        = "../terraform-gcp-modules/terraform-gcp-compute-lb-http"
  region        = var.region
  zone          = var.zone
  name          = local.name
  #accepted protocols http or https
  backend_protocol  = var.backend_protocol
  backend_port  = var.backend_port
  forwarding_port = 443
  domains       = var.domains
  instances = [module.example.Windows-id, module.example2.Windows.id]
  health_check = var.health_check
  depends_on   = [module.example]
}

resource "null_resource" "run-ansible-destroy-web" {
  for_each = toset(module.example.Linux-VM)
  triggers = {
    vmname           = each.key
    ansible_user     = var.ansible_user
    ansible_password = var.ansible_password
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/destroy_playbook.yaml -i 10.10.102.20, --extra-vars 'vmname=${self.triggers.vmname} ansible_user=${self.triggers.ansible_user} ansible_password=${self.triggers.ansible_password} ansible_connection=winrm ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_winrm_transport=ntlm'"
    when    = destroy
  }
}

### When adding additional modules stop your copy here. ###
# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      windows-address = module.example.Windows-nat-ip
      linux-address   = module.example.Linux-ip
    }
  )
  filename = "inventory"
}

resource "null_resource" "run-ansible" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/${var.stack}_playbook.yaml -i inventory -e 'ENVKEY=${var.envkey} ansible_user=${var.ansible_user} ansible_password=${var.ansible_password} ansible_become_password=${var.ansible_password} admin_groups=${var.admin_groups} allow_groups=${var.allow_groups}'"
  }
  depends_on = [module.example]
}