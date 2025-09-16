terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  owner = var.github_organization
  token = coalesce(
    try(env("GITHUB_TOKEN"), null),
    var.github_token
  )
}
