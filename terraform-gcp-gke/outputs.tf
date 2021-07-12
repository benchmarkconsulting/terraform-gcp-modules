output "cluster_names"{
    value = google_container_cluster.primary.name
    description = "The name of the gke cluster"
}

output "cluster_locations"{
    value = google_container_cluster.primary.location
    description = "The regions or zones in which the cluster will be created"
}

output "project_name"{
    value = google_container_cluster.primary.project
    description = "The name of the project tht contains the cluster"
}