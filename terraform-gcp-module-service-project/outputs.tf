output "project_name" {
  value = google_project.svcproject.name
}

output "project_id" {
  value = google_project.svcproject.project_id
  depends_on = [
    google_project.svcproject,
    google_compute_shared_vpc_service_project.shared_vpc_attachment,
  ]
}

output "name" {
  description = "Resource name of the budget. Values are of the form `billingAccounts/{billingAccountId}/budgets/{budgetId}.`"
  value       = var.create_budget ? google_billing_budget.budget[0].name : ""
}

output "number" {
  value = google_project.svcproject.number
}




