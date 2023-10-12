provider "github" {
  owner = var.github_owner
  token = var.github_token
}

locals {
  repository_exists = try(data.github_repository.existing.node_id != "", false)
}

data "github_repository" "existing" {
  provider  = github
  full_name = "${var.github_owner}/${var.repository_name}"
}

resource "github_repository" "this" {
  count      = local.repository_exists ? 0 : 1
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true

  lifecycle {
    ignore_changes = [name, visibility]
  }
}

resource "github_repository_deploy_key" "this" {
  depends_on = [github_repository.this]
  count      = local.repository_exists ? 1 : 0
  title      = var.public_key_openssh_title
  repository = var.repository_name
  key        = var.public_key_openssh
  read_only  = false
  
  lifecycle {
    prevent_destroy = true 
  }
}


# resource "github_repository" "this" {
#   name       = var.repository_name
#   visibility = var.repository_visibility
#   auto_init  = true
#   lifecycle {
#     ignore_changes = [name, visibility]
#   }
# }

# data "github_repository" "existing" {
#   full_name = "${var.github_owner}/${var.repository_name}"
#   depends_on = [github_repository.this]
# }

# resource "github_repository_deploy_key" "this" {
#   title      = var.public_key_openssh_title
#   repository = data.github_repository.existing.name
#   key        = var.public_key_openssh
#   read_only  = false
# }