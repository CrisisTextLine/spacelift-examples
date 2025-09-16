variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_tags_simple" {
  description = "Tags to assign to the S3 bucket"
  type        = string
  default     = ""

  # Expected format: "key1=value1,key2=value2" (no spaces). Example: "environment=dev,owner=platform"
  # If you need more complex values or dynamic values, use bucket_tags_complex instead.
  validation {
    # Regex notes:
    # ^$              -> allow empty string
    # |                -> OR
    # ^(pair)(,pair)*$ -> one or more key=value pairs separated by commas
    # key char class: A-Z a-z 0-9 _ . - (dash placed at end so it is literal)
    # value: any run of chars excluding '=' and ',' (simplistic but fine here)
  # Allow optional spaces after commas by permitting leading spaces before the key.
  # Use explicit space and tab class instead of \s (not supported) for optional whitespace
  condition = can(regex("^$|^([A-Za-z0-9_.-]+=[^=,]*)(,[ \t]*[A-Za-z0-9_.-]+=[^=,]*)*$", var.bucket_tags_simple))
  error_message = "bucket_tags_simple must be a comma-separated list of key=value pairs (alphanumeric, dash, underscore, dot in keys). Optional spaces after commas allowed. Example: environment=dev, owner=platform"
  }
}

variable "bucket_tags_complex" {
  description = "Tags to assign to the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "github_organization" {
  description = "GitHub organization where the repository is located"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository where the S3 bucket configuration will be committed"
  type        = string
  default     = "s3"
}

variable "username" {
  description = "Username of the user who triggered the run"
  type        = string
}

variable "user_login" {
  description = "Login of the user who triggered the run"
  type        = string
}

variable "branch" {
  description = "Branch of the GitHub repository to commit to"
  type        = string
  default     = "main"
}