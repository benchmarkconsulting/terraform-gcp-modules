locals {
  prefix                = var.prefix != "" ? "${var.prefix}-" : ""
  service_accounts_list = [for name in var.names : google_service_account.service_accounts[name]]
  emails_list           = [for account in local.service_accounts_list : account.email]
  iam_emails_list       = [for email in local.emails_list : "serviceAccount:${email}"]
  names                 = toset(var.names)
  name_role_pairs       = setproduct(local.names, toset(var.project_roles))
  project_roles_map_data = zipmap(
    [for pair in local.name_role_pairs : "${pair[0]}-${pair[1]}"],
    [for pair in local.name_role_pairs : {
      name = pair[0]
      role = pair[1]
    }]
  )
}

# create service accounts
resource "google_service_account" "service_accounts" {
  for_each     = local.names
  account_id   = "${local.prefix}${lower(each.value)}"
  display_name = var.display_name
  description  = index(var.names, each.value) >= length(var.descriptions) ? var.description : element(var.descriptions, index(var.names, each.value))
  project      = var.project_id
}

# common roles
resource "google_project_iam_member" "project-roles" {
  for_each = local.project_roles_map_data

  project = element(
    split(
      "=>",
      each.value.role
    ),
    0,
  )

  role = element(
    split(
      "=>",
      each.value.role
    ),
    1,
  )

  member = "serviceAccount:${google_service_account.service_accounts[each.value.name].email}"
}