```hcl
module "gke" {
    source = "git::https://github.com/benchmarkconsulting/gcp-terraform-modules//gke"
    cluster = [
{
  name                       = "gke-test-1"
  region                     = "us-east1"
  location                   = "us-east1-b"
    network              = "example-vpc"
  subnetwork                 = "subnet-01"
  ip_range_pods              = "subnet-01-secondary-01"
  ip_range_services          = "subnet-01-secondary-02"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true
  network_policy_config      = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.16.0.0/28"
  remove_default_node_pool   = true
  default_max_pods_per_node = 8
  initial_node_count         = 1
    cidr_block   = "10.0.0.0/24"
      display_name = "main-network"
},
            ]
  node_pools = [
    {
      name               = "default-node-pool"
      location           = "us-east1-b"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 10
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      cluster_name       = "gke-test-1"
      preemptible        = false
      initial_node_count = 3
      node_count = 3
    },
  ]
}
  ```
