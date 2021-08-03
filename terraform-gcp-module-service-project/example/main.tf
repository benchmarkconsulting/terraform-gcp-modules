/******************************************
   Service Project for ProvisionerProd
 *****************************************/
module "provisionerprod-project" {
  source                            = "../../../modules-gcp/module-service-project"
  name                              = "provisionerprod"
  folder_id                         = module.it-folders.ids["Provisioner"]
  billing_account                   = "0193C6-E56AA8-81B0DB"
  enable_shared_vpc_service_project = true
  shared_vpc                        = module.shared-services-host-project.project_id
  create_budget                     = false
  projects                          = [module.provisionerprod-project.project_id]
  amount                            = "100"
  depends_on                        = [module.shared-services-vpc, module.it-folders]
}

resource "google_compute_subnetwork_iam_binding" "provisionerprod" {
  project    = module.shared-services-host-project.project_id
  region     = "northamerica-northeast1"
  subnetwork = "projects/${module.shared-services-host-project.project_id}/regions/northamerica-northeast1/subnetworks/provisionerprod"
  role       = "roles/compute.networkUser"
  members = [
    "serviceAccount:${module.provisionerprod-project.number}-compute@developer.gserviceaccount.com",
  ]
}