Github Repository Terraform Module

This Terraform module manages a Github repository and its associated deploy keys. It creates a new repository if one does not already exist. Also, it generates a deploy key for the repository.
Inputs

    github_owner: The Github username or organization name under which the repository resides or will be created.
    github_token: The Github Personal Access Token (PAT) used for authenticating API requests. Ensure it has sufficient permissions to manage repositories and deploy keys.
    repository_name: The name of the Github repository to be managed. If a repository with this name does not exist under the specified owner, a new one will be created.
    repository_visibility: The visibility of the repository. Valid values are 'public', 'private', or 'internal'.
    public_key_openssh: The public SSH key to be added as a deploy key to the repository. This must be provided in OpenSSH format.
    public_key_openssh_title: The title for the deploy key on Github.

Outputs

    repository_name: The name of the created or existing repository. If a repository with the input repository_name already exists under the specified owner, this output will return the name of that existing repository.

Remember, the outputs of a Terraform module are accessible from the root module (or module that called the sub-module). If your Github repository module is called within another module, you can access the repository_name output like this:

module "github_repository" {
  source                 = "github.com/bartaadalbert/tf-github-repository?ref=develop"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux"
}

module "tls_private_key" {
  source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
}
