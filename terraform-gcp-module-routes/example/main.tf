/******************************************
  Routes
 *****************************************/
 module "routes" {
   source       = "../../../modules-gcp/module-routes"
   project_id   = module.shared-services-host-project.project_id
  network_name = module.shared-services-host-project.network_name
  routes = [
     {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
     },
   ]
 }