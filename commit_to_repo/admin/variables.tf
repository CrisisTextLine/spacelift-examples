variable "space" {
  type = string
}

variable "worker_pool" {
  type = string
}

variable "repo_name" {
  description = "The name of the GitHub repository where the S3 bucket configuration will be committed"
  type        = string
  default     = "s3-example"
}

variable "aws_integration_name" {
  description = "The name of the Spacelift AWS integration to attach to the stack"
  type        = string
  default     = "demo"
}
