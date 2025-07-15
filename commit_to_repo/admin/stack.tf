resource "spacelift_stack" "s3_bucket_management" {
  name           = "S3 Bucket Management"
  branch         = "main"
  space_id       = var.space
  repository     = "s3"
  autodeploy     = true
  worker_pool_id = var.worker_pool
}

resource "spacelift_aws_integration_attachment" "default" {
  stack_id       = spacelift_stack.s3_bucket_management.id
  integration_id = "01JAZPBRW3K2YB0K7F58NZSDY6"
}
