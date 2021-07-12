### When adding additional modules start your copy here. ###
provider "google" {
  project     = "sandbox-279017"
  region      = "northamerica-northeast1"
}
terraform {
  backend "gcs" {
    bucket  = "test-lb"
    prefix  = "terraform/test/loadbalancer"
  }
}
module "linux_example" {
  source              = "../../../modules-gcp/module-compute"
  instances_count     = var.instances_count
  vmname              = var.vmname
  is_windows_image    = var.is_windows_image
  zone                = var.zone
  machine_type        = var.machine_type
  tags                = var.tags
  image               = var.image
  disk_size_gb        = var.disk_size_gb
  subnetwork          = var.subnetwork
  # To add additional disks uncomment the lines below and add the variable to the variables.tf and terraform.tfvars
  # data_disk = {
  #  disk1 = {
  #    size_gb                   = var.data_disk_size_gb,
  #    thin_provisioned          = true,
  #  },
  #}
}
resource "null_resource" "run-ansible-destroy-web" {
  for_each = toset(module.linux_example.Linux-VM)
  triggers = {
    vmname = each.key
    ansible_user = var.ansible_user
    ansible_password = var.ansible_password
  }
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/destroy_playbook.yaml -i 10.10.102.20, --extra-vars 'vmname=${self.triggers.vmname} ansible_user=${self.triggers.ansible_user} ansible_password=${self.triggers.ansible_password} ansible_connection=winrm ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_winrm_transport=ntlm'"
    when = destroy
  }
}
### When adding additional modules stop your copy here. ###
# Create the local ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      linux-address = module.linux_example.Linux-ip
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
  depends_on = [module.linux_example]
}
