/******************************************
  Service Account
 *****************************************/
module "veem-service-account" {
  source     = "../../../modules-gcp/module-serviceaccount"
  project_id = module.backupprod-project.project_id
  prefix     = "veeam"
  description = "Service account for Veeam Backups"
  names         = ["sa"]
}