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
  file              = "${var.s3_bucket_name}.tf"
  commit_message    = "Managed by Spacelift"
  commit_author     = "Spacelift"
  autocreate_branch = true
  content = templatefile("${path.module}/s3_template.tf", {
    s3_bucket_name = var.s3_bucket_name
    s3_bucket_tags = var.s3_bucket_tags
  })
}
