output "repository_name" {
  description = "The name of the created repository."
  value       = try(github_repository.this.name, null)
}

