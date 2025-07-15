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

locals {
  bucket_tags_simple = { for tag in [
    for v in split(",", var.bucket_tags_simple) : v
  ] : split("=", tag)[0] => split("=", tag)[1] }
}

resource "github_repository_file" "foo" {
  repository     = "s3"
  branch         = "main"
  file           = "${var.bucket_name}.tf"
  commit_message = "Managed by Spacelift"
  commit_author  = "Spacelift"
  commit_email   = "blueprint@spacelift.io"
  content = templatefile("${path.module}/s3.tftpl", {
    bucket_name = var.bucket_name
    bucket_tags = var.bucket_tags_simple != "" ? local.bucket_tags_simple : var.bucket_tags_complex
  })
}
