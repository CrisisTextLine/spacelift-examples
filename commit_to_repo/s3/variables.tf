variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_tags_simple" {
  description = "Tags to assign to the S3 bucket"
  type        = string
  default     = "{}"
}

variable "bucket_tags_complex" {
  description = "Tags to assign to the S3 bucket"
  type        = string
  default     = "{}"
}

variable "github_token" {
  description = "GitHub token with permissions to commit to the repository"
  type        = string
}

variable "github_organization" {
  description = "GitHub organization where the repository is located"
  type        = string
}
