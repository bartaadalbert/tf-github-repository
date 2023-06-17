provider "github" {
  owner = var.github_owner
  token = var.github_token
}

resource "github_repository" "this" {
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true
  lifecycle {
    ignore_changes = [name, visibility]
  }
}

data "github_repository" "existing" {
  full_name = "${var.github_owner}/${var.repository_name}"
  depends_on = [github_repository.this]
}

resource "github_repository_deploy_key" "this" {
  title      = var.public_key_openssh_title
  repository = data.github_repository.existing.name
  key        = var.public_key_openssh
  read_only  = false
}