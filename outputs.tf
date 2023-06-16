output "repository_name" {
  description = "The name of the created repository."
  value       = try(github_repository.this[0].name, null)
}

