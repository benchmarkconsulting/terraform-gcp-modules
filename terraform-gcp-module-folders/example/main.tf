/******************************************
  Folder Creation for top Level Org
 *****************************************/
module "top-level" {
  source = "../../../modules-gcp/module--folders"
  parent = "organizations/370753128095"
  names = [
    "CloudCore",
  ]
  set_roles = true
  all_folder_admins = [
    "group:gcp-organization-admins@univeris.com",
  ]
}