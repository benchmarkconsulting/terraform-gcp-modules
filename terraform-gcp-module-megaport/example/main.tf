/******************************************
  MegaPort
 *****************************************/
module "megaport" {
  source       = "../../../modules-gcp/module-megaport"
  project      = module.shared-services-host-project.project_id
  name         = "megaport"
  region       = "northamerica-northeast1"
  network_name = module.shared-services-host-project.network_name
  description  = "MegaPort Interconnect"
  depends_on   = [module.shared-services-vpc]
}