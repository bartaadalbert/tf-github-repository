provider "github" {
  owner = var.github_owner
  token = var.github_token
}

data "github_repository" "existing" {
  full_name = "${var.github_owner}/${var.repository_name}"
}

locals {
  repository_exists = data.github_repository.existing.id != null
}

# Debug output
output "repository_exists" {
  value = local.repository_exists
}

resource "github_repository" "this" {
  count       = local.repository_exists ? 1 : 0
  name        = var.repository_name
  visibility  = var.repository_visibility
  auto_init   = true
  depends_on  = [data.github_repository.existing]
}

resource "github_repository_deploy_key" "this" {
  count      = local.repository_exists ? 1 : 0
  repository = local.repository_exists ? data.github_repository.existing.name : null
  title      = var.public_key_openssh_title
  key        = var.public_key_openssh
  read_only  = false
}
