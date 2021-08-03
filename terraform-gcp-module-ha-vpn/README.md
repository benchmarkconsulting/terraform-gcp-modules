/******************************************
  ha vpn
 *****************************************/
module "ha-vpn-univeris" {
  source                        = "../../modules-gcp/module-ha-vpn"
  gcp_region                    = "northamerica-northeast1"
  gcp_project                   = module.shared-services-host-project.project_id
  name                          = "univeris"
  network_name                  = module.shared-services-host-project.network_name
  ha_ext_vpn_gateway_ip_1       = "195.111.222.100"
  ha_ext_vpn_gateway_ip_2       = "195.111.222.200"
  ha_shared_secret              = "1c07c4dc414077d02ac670fcaefabba6"
  ha_router_interface1_ip_range = "169.254.0.1/30"
  ha_router_interface2_ip_range = "169.254.1.1/30"
  ha_router_peer1_ip_address    = "169.254.0.2"
  ha_router_peer2_ip_address    = "169.254.1.2"
  ha_router_asn                 = "65020"
  ha_peer_asn                   = "65030"
}