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
  token = var.github_token
}


resource "github_repository_file" "foo" {
  repository        = "s3"
  branch            = "does/not/exist"
  file              = "${var.bucket_name}.tf"
  commit_message    = "Managed by Spacelift"
  commit_author     = "Spacelift"
  commit_email      = "blueprint@spacelift.io"
  autocreate_branch = true
  content           = file("${path.module}/s3.tftpl")
}
