# Commented out nat ip as the access_config block was removed. It will be kept commented in case it is needed sometime in the future.
# To restore, please add access_config { // } to the network_interface block in main.tf
#output "Windows-nat-ip" {
#  description = "External ip address of the deployed VM"
#  value       = google_compute_instance.Windows.*.network_interface[*][0].access_config[0].nat_ip
#}

output "Windows-VM" {
  description = "name of the deployed Windows VM"
  value       = google_compute_instance.Windows.*.name
}

output "Windows-ip" {
  description = "internal ip address of the deployed VM"
  value       = google_compute_instance.Windows.*.network_interface[*][0].network_ip
}

#output "Linux-nat-ip" {
#  description = "External ip address of the deployed VM"
#  value       = google_compute_instance.Linux.*.network_interface[*][0].access_config[0].nat_ip
#}

output "Linux-VM" {
  description = "name of the deployed Linux VM"
  value       = google_compute_instance.Linux.*.name
}

output "Linux-ip" {
  description = "internal ip address of the deployed VM"
  value       = google_compute_instance.Linux.*.network_interface[*][0].network_ip
}

output "Windows-id" {
  description = "id of the deployed Windows VM"
  value       = google_compute_instance.Windows.*.self_link
}

output "Linux-id" {
  description = "id of the deployed linux VM"
  value       = google_compute_instance.Linux.*.self_link
}
