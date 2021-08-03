/******************************************
  classic vpn with bgp
 *****************************************/
module "classic-vpn-bgp-test" {
  source                                = "../../modules-gcp/module-classic-vpn-bgp"
  gcp_region                            = "northamerica-northeast1"
  gcp_project                           = module.shared-services-host-project.project_id
  name                                  = "test"
  network_name                          = module.shared-services-host-project.network_name
  classic_vpn_shared_secret             = "6290e27edbd"
  classic_vpn_ext_gateway_ip            = "195.111.222.100"
  classic_vpn_router_interface_ip_range = "169.254.2.1/30"
  classic_vpn_router_peer_ip_address    = "169.254.2.2"
  classic_vpn_router_asn                = "65040"
  classic_vpn_peer_asn                  = "65050"
}