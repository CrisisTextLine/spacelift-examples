locals {
  blueprint    = yamldecode(file("${path.module}/blueprint/blueprint.yaml"))
  blueprint_pr = yamldecode(file("${path.module}/blueprint/pr_blueprint.yaml"))
}

resource "spacelift_blueprint" "no_pr_blueprint" {
  name     = "Create S3 Bucket (no PR)"
  space    = data.spacelift_current_space.current.id
  state    = "PUBLISHED"
  template = local.blueprint
}

resource "spacelift_blueprint" "pr_blueprint" {
  name     = "Create S3 Bucket (with PR)"
  space    = data.spacelift_current_space.current.id
  state    = "PUBLISHED"
  template = local.blueprint_pr
}