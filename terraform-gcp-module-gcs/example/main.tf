/******************************************
  Storage Bucket for Foundation-Bucket-RemoteBackend
 *****************************************/
module "foundation-bucket-remotebackend" {
  source = "../../../modules-gcp/module-gcs"

  name       = "foundation-bucket-remotebackend"
  project_id = module.shared-services-host-project.project_id
  location   = "northamerica-northeast1"
  depends_on = [module.shared-services-host-project]
  iam_members = [{
    role   = "roles/storage.admin"
    member = "user:matt.cole@benchmarkcorp.com"
    group  = "group:gcp-organization-admins@univeris.com"
  }]
}