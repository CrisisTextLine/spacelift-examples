terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  token = var.github_token
}


resource "github_repository_file" "foo" {
  repository        = "s3"
  branch            = "does/not/exist"
  file              = "${var.bucket_name}.tf"
  commit_message    = "Managed by Spacelift"
  commit_author     = "Spacelift"
  autocreate_branch = true
  content = templatefile("${path.module}/s3_template.tf", {
    bucket_name = var.bucket_name
    bucket_tags = var.bucket_tags
  })
}
