/******************************************
  classic vpn with static
  *****************************************/
module "classic-vpn-static-univeris" {
  source                                = "../../modules-gcp/module-classic-vpn-static"
  gcp_region                            = "northamerica-northeast1"
  gcp_project                           = module.shared-services-host-project.project_id
  name                                  = "univeris"
  network_name                          = module.shared-services-host-project.network_name
  classic_vpn_shared_secret             = "7edbd"
  classic_vpn_ext_gateway_ip            = "11.33.44.55"
  dest_range = "10.1.72.0/23"

}
