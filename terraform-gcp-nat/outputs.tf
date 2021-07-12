output "router_name"{
    value = google_compute_router.router.name
    description = "The name of the router being created"
}

output "nat_name"{
    value = google_compute_router_nat.nat.name
    description = "The name of the NAT router being created"
}