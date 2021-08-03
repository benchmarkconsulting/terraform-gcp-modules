/******************************************
  Host Foundation Project Creation
 *****************************************/
module "shared-services-host-project" {
  source                            = "../../../modules-gcp/module-sharedvpc"
  project_id                        = module.shared-services-host-project.project_id
  name                              = "foundation"
  org_id                            = "370753128095"
  billing_account                   = "0193C6-E56AA8-81B0DB"
  enable_shared_vpc_host_project    = true
  enable_shared_vpc_service_project = false
  network_name                      = "foundation-network"
  description                       = "Shared Services Network"
  depends_on                        = [module.it-folders]
}