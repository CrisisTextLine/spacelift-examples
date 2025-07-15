data "spacelift_current_space" "current" {}

data "spacelift_aws_integration" "default" {
  name = "demo"
}
