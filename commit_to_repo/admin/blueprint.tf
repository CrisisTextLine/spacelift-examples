resource "spacelift_blueprint" "s3_bucket" {
  name     = "Create S3 Bucket"
  space    = data.spacelift_current_space.current.id
  state    = "PUBLISHED"
  template = file("${path.module}/blueprint/blueprint.yaml")
}
