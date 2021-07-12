resource "google_compute_firewall" "default" {
 count      = length(var.firewall)
 name       = lookup(var.firewall[count.index], "name", "")
 network    = lookup(var.firewall[count.index], "network", "")
 
 allow {
   protocol = lookup(var.firewall[count.index], "protocol", "")
   ports    = [lookup(var.firewall[count.index], "ports", "")]
 }
 source_ranges = [lookup(var.firewall[count.index], "source_ranges", "")]
 target_tags   = [lookup(var.firewall[count.index], "target_tags", "")]
}
