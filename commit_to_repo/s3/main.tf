locals {
  bucket_tags_simple = { for tag in [
    for v in split(",", var.bucket_tags_simple) : v
  ] : split("=", tag)[0] => split("=", tag)[1] }
}

resource "github_repository_file" "foo" {
  repository     = var.github_repository
  branch         = "main"
  file           = "${var.bucket_name}.tf"
  commit_message = "Create S3 bucket from spacelift blueprint"
  commit_author  = var.username
  commit_email   = var.user_login
  content = templatefile("${path.module}/s3.tftpl", {
    bucket_name = var.bucket_name
    bucket_tags = var.bucket_tags_simple != "" ? local.bucket_tags_simple : var.bucket_tags_complex
  })
}
