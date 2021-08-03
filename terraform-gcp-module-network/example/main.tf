/******************************************
  Network Creation
 *****************************************/
module "shared-services-vpc" {
  source       = "../../../modules-gcp/module-network"
  project_id   = module.shared-services-host-project.project_id
  network_name = module.shared-services-host-project.network_name
  depends_on   = [module.shared-services-host-project]
  subnets = [
    {
      subnet_name   = "cloudcoreprod"
      subnet_ip     = "10.30.0.0/24"
      subnet_region = "northamerica-northeast1"
    },
      ]
}