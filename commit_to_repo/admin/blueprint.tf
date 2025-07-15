resource "spacelift_blueprint" "s3_bucket" {
  name     = "Create S3 Bucket"
  space    = "examples-01JXAYSXR35QCSGCBTZTENP0Z7"
  state    = "PUBLISHED"
  template = file("${path.module}/blueprint/blueprint.yaml")
}
