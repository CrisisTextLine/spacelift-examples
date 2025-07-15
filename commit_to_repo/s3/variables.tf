variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_tags" {
  description = "Tags to assign to the S3 bucket"
  type        = map(string)
}


variable "github_token" {
  description = "GitHub token with permissions to commit to the repository"
  type        = string
}
