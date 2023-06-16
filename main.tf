provider "github" {
  owner = var.github_owner
  token = var.github_token
}

data "github_repository" "existing" {
  full_name = "${var.github_owner}/${var.repository_name}"
}

locals {
  repository_exists = try(data.github_repository.existing.id, null) != null ? 0 : 1
}

resource "github_repository" "this" {
  count      = local.repository_exists
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true
}

resource "github_repository_deploy_key" "this" {
  count      = local.repository_exists
  title      = var.public_key_openssh_title
  repository = github_repository.this[count.index].name
  key        = var.public_key_openssh
  read_only  = false
}