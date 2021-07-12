output "firewall_name" {
    value = google_compute_firewall.default.*.name
    description = "The names of the firewalls being created"
}
output "firewall_network" {
     value = google_compute_firewall.default.*.network
     description = "The names of the networks the firewalls are attached to"
}
output "firewall_src_ranges" {
     value = google_compute_firewall.default.*.source_ranges
     description = "The source IP addresses that the firewall will apply to"
}

