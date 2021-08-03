locals {
  name = var.vm_name
  project = "sandbox-279017"
  region  = "northamerica-northeast1"
}

provider "google" {
  project = local.project
  region  = local.region
}
provider "google-beta" {
  project = local.project
  region  = local.region
}

module "example" {
  source              = "../../module-compute"
  instances_count     = 1
  vmname              = local.name
  machine_type        = var.machine_type
  image               = var.image
  is_windows_image    = var.is_windows_image
  zone                = "northamerica-northeast1-a"
  tags                = var.tags
  disk_size_gb        = var.disk_size_gb
  data_disk_size_gb   = var.data_disk_size_gb
  subnetwork          = var.subnetwork
  startup-script      = var.startup_script
}

module "example2" {
  source              = "../../module-compute"
  instances_count     = 1
  vmname              = local.name
  machine_type        = var.machine_type
  image               = var.image
  is_windows_image    = var.is_windows_image
  zone                = "northamerica-northeast1-b"
  tags                = var.tags
  disk_size_gb        = var.disk_size_gb
  data_disk_size_gb   = var.data_disk_size_gb
  subnetwork          = var.subnetwork
  startup-script      = var.startup_script
}

module "umig1" {
  name = "umig1"
  source        = "../../module-umig"       
  instances = module.example.Windows-id
  zone = "northamerica-northeast1-a"
   health_check = var.health_check
}

module "umig2" {
  name = "umig2"
  source        = "../../module-umig"       
  instances = module.example2.Windows-id
  zone = "northamerica-northeast1-b"
   health_check = var.health_check
}

// module "load_balancer" {
//   source        = "../../module-lb-http"
//   region        = var.region
//   zone          = var.zone
//   name          = local.name
//   #accepted protocols http or https
//   backend_protocol  = var.backend_protocol
//   backend_port  = var.backend_port
//   forwarding_port = 443
//   health_check = var.health_check
//   domains       = var.domains
//   depends_on   = [module.example]
//   backends = {
//     groups = [
//       {
//         group = module.umig1.instance_group
//       }
//     ]
//   }
// }