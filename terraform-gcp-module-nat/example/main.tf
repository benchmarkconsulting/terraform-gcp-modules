/******************************************
  NAT Creation for outbound Access
 *****************************************/
module "nat" {
  source                 = "../../../modules-gcp/module-nat"
  project_id             = module.shared-services-host-project.project_id
  region                 = "northamerica-northeast1"
  network                = module.shared-services-host-project.network_name
  router_name            = "nat-router-01"
  nat_name               = "nat-01"
  network_name           = module.shared-services-host-project.network_name
  nat_ip_allocate_option = "AUTO_ONLY"
  depends_on             = [module.shared-services-vpc]
}