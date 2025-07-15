resource "spacelift_stack" "s3_bucket_management" {
  name                    = "S3 Bucket Management"
  branch                  = "main"
  space_id                = var.space
  repository              = "s3"
  autodeploy              = true
  worker_pool_id          = var.worker_pool
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_version       = "1.10.2"
}

resource "spacelift_aws_integration_attachment" "default" {
  stack_id       = spacelift_stack.s3_bucket_management.id
  integration_id = data.spacelift_aws_integration.default.id
}
