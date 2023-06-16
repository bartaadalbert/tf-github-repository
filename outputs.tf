output "repository_name" {
  description = "The name of the created repository."
  value       = (count(github_repository.this) > 0 ? github_repository.this[0].name : null)
}
