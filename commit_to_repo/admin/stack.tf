resource "spacelift_stack" "s3_bucket_management" {
  name        = "S3 Bucket Management"
  space       = var.space
  branch      = "main"
  repository  = "s3"
  autodeploy  = true
  worker_pool = var.worker_pool
}

resource "spacelift_aws_integration_attachement" "default" {
  stack_id       = spacelift_stack.s3_bucket_management.id
  integration_id = data.spacelift_aws_integration.default.id
}
