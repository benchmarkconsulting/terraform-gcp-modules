locals {
  win_vmnames   = google_compute_instance.Windows.*.name
  linux_vmnames = google_compute_instance.Linux.*.name
  win_disknames = var.data_disk_size_gb != null ? flatten([
    for vms in local.win_vmnames : [
      for index, disks in var.data_disk_size_gb : {
        name   = vms
        disk   = disks
        number = index
      }
    ]
  ]) : []
  linux_disknames = var.data_disk_size_gb != null ? flatten([
    for vms in local.linux_vmnames : [
      for index, disks in var.data_disk_size_gb : {
        name   = vms
        disk   = disks
        number = index
      }
    ]
  ]) : []
}
#####################################################
#                                                   #
# Start of Windows Section                          #
#                                                   #
#####################################################
resource "google_compute_disk" "Windows" {
  for_each = var.is_windows_image ? { for idx, names in local.win_disknames : idx => names } : {}
  name     = "${each.value.name}-datadisk${each.value.number}"
  type     = "pd-standard"
  zone     = var.zone
  size     = each.value.disk
}

resource "google_compute_attached_disk" "Windows" {
  for_each   = var.is_windows_image ? { for idx, names in local.win_disknames : idx => names } : {}
  disk       = "${each.value.name}-datadisk${each.value.number}"
  instance   = each.value.name
  depends_on = [google_compute_disk.Windows]
  zone       = var.zone
}

resource "google_compute_instance" "Windows" {
  count                     = var.is_windows_image ? var.instances_count : 0
  name                      = "%{if var.vmnameliteral != ""}${var.vmnameliteral}%{else}${var.vmname}${count.index + 1}${var.vmnamesuffix}%{endif}"
  machine_type              = var.machine_type
  zone                      = var.zone
  tags                      = var.tags
  enable_display            = true
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
    }
  }
  labels = var.labels

  lifecycle {
    ignore_changes = [attached_disk,boot_disk[0].initialize_params[0].image]
  }

  network_interface {
    subnetwork = var.subnetwork
    subnetwork_project = var.subnetwork_project
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }
  metadata = {
    sysprep-specialize-script-url = "gs://provisionerprod-bucket-startup-scripts/wingcp_config.ps1"
  }
}

#####################################################
#                                                   #
# End of Windows Section                            #
#                                                   #
#####################################################

#####################################################
#                                                   #
# Start of Linux Section                            #
#                                                   #
#####################################################

resource "google_compute_disk" "Linux" {
  for_each = var.is_windows_image ? {} : { for idx, names in local.linux_disknames : idx => names }
  name     = "${each.value.name}-datadisk${each.value.number}"
  type     = "pd-standard"
  zone     = var.zone
  size     = each.value.disk
}

resource "google_compute_attached_disk" "Linux" {
  for_each   = var.is_windows_image ? {} : { for idx, names in local.linux_disknames : idx => names }
  disk       = "${each.value.name}-datadisk${each.value.number}"
  instance   = each.value.name
  depends_on = [google_compute_disk.Linux]
  zone       = var.zone
}

resource "google_compute_instance" "Linux" {
  count                     = var.is_windows_image ? 0 : var.instances_count
  name                      = "%{if var.vmnameliteral != ""}${var.vmnameliteral}%{else}${var.vmname}${count.index + 1}${var.vmnamesuffix}%{endif}"
  machine_type              = var.machine_type
  zone                      = var.zone
  tags                      = var.tags
  enable_display            = true
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
    }
  }

  labels = var.labels

  lifecycle {
    ignore_changes = [attached_disk, boot_disk[0].initialize_params[0].image]
  }

  network_interface {
    subnetwork = var.subnetwork
    subnetwork_project = var.subnetwork_project
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }
  
  metadata = {
    ssh-keys = var.pub_ssh
    startup-script-url = var.startup
  }

}

#####################################################
#                                                   #
# End of Linux Section                              #
#                                                   #
#####################################################
