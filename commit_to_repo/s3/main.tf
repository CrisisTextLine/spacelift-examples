locals {
  # Split the simple tags string into a list. Empty string -> empty list.
  # Use trimspace to remove surrounding whitespace; original code used trim which in OpenTofu requires a cutset argument.
  bts_raw = var.bucket_tags_simple != "" ? split(",", trimspace(var.bucket_tags_simple)) : []

  # Filter out any entries that don't contain '=' just in case (they'll be ignored) and trim whitespace.
  bts_kv = [for t in local.bts_raw : trimspace(t) if can(regex("=", t))]

  # Turn into a map. We already validated format, but we still guard with can() to avoid index errors.
  bucket_tags_simple = { for tag in local.bts_kv :
    (can(element(split("=", tag), 0)) ? element(split("=", tag), 0) : "") =>
    (can(element(split("=", tag), 1)) ? element(split("=", tag), 1) : "")
    if can(element(split("=", tag), 1)) && can(element(split("=", tag), 0))
  }

  is_pr          = var.branch != "main"
  commit_message = "feat: create S3 bucket ${var.bucket_name}"
}

resource "github_repository_file" "foo" {
  repository     = var.github_repository
  branch         = local.is_pr ? github_branch.this[0].branch : var.branch
  file           = "${var.bucket_name}.tf"
  commit_message = local.commit_message
  commit_author  = var.username
  commit_email   = var.user_login
  content = templatefile("${path.module}/s3.tftpl", {
    bucket_name = var.bucket_name
    bucket_tags = var.bucket_tags_simple != "" ? local.bucket_tags_simple : var.bucket_tags_complex
  })
}

resource "github_branch" "this" {
  count      = local.is_pr ? 1 : 0
  repository = var.github_repository
  branch     = var.branch
}

resource "github_repository_pull_request" "this" {
  count = local.is_pr ? 1 : 0

  base_repository = var.github_repository
  base_ref        = "main"
  head_ref        = github_branch.this[0].branch
  title           = local.commit_message
  body            = "This PR creates an S3 bucket named ${var.bucket_name} with the specified tags."

  depends_on = [
    github_repository_file.foo
  ]
}

locals {
  pr_id = local.is_pr ? github_repository_pull_request.this[0].number : ""
}

output "pr_url" {
  value = "https://github.com/${var.github_organization}/${var.github_repository}/pull/${local.pr_id}"
}