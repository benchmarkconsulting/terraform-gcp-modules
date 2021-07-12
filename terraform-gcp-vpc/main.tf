locals {
  network_self_link = var.create_network ? google_compute_network.vpc_network[0].self_link : data.google_compute_network.vpc_network[0].self_link
  network_name      = var.create_network ? google_compute_network.vpc_network[0].name : data.google_compute_network.vpc_network[0].name
}
###VPC configuration
resource "google_compute_network" "vpc_network" {
    count                   = var.create_network ? 1 : 0
    name                    = var.network_name
    auto_create_subnetworks = var.auto_create_subnetworks
    routing_mode            = var.routing_mode
    description             = var.description
}

data "google_compute_network" "vpc_network" {
  count   = var.create_network ? 0 : 1
  name    = var.network_name
}


###	Shared VPC

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  count   = var.shared_vpc_host == "true" ? 1 : 0
  project = var.project_id
}

### SUBNETS

resource "google_compute_subnetwork" "subnetwork" {
      count                    = length(var.subnet)
      name                     = var.subnet[count.index]["subnet_name"]
      ip_cidr_range            = var.subnet[count.index]["subnet_ip"]
      network                  = local.network_self_link
      secondary_ip_range       = [for i in range(length(contains(keys(var.secondary_ranges), var.subnet[count.index]["subnet_name"]) == true ? var.secondary_ranges[var.subnet[count.index]["subnet_name"]] : [])) : var.secondary_ranges[var.subnet[count.index]["subnet_name"]][i]]
      description              = lookup(var.subnet[count.index], "description", null)
      depends_on               = [google_compute_network.vpc_network]
  }

  data "google_compute_subnetwork" "created_subnets" {
  count   = length(var.subnet)
  name    = element(google_compute_subnetwork.subnetwork.*.name, count.index)
  region  = element(google_compute_subnetwork.subnetwork.*.region, count.index)
}


###	Routes
 
resource "google_compute_route" "route" {
  count                  = length(var.routes)
  network                = local.network_name
  name                   = lookup(var.routes[count.index], "name", format("%s-%s-%d", lower(local.network_name), "route", count.index))
  description            = lookup(var.routes[count.index], "description", "")
  tags                   = compact(split(",", lookup(var.routes[count.index], "tags", "")))
  dest_range             = lookup(var.routes[count.index], "destination_range", "")
  next_hop_gateway       = lookup(var.routes[count.index], "next_hop_internet", "false") == "true" ? "default-internet-gateway" : ""
  priority               = 1000

  depends_on = [
    google_compute_subnetwork.subnetwork,
  ]
}