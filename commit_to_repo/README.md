# Spacelift S3 Bucket Blueprint

This project provides an automated S3 bucket creation workflow using Spacelift blueprints with a GitOps approach. When triggered, it generates S3 bucket configurations and commits them back to your GitHub repository.

## Overview

The project consists of two main components:

1. **Admin Configuration** (`admin/`) - Defines the Spacelift blueprint and stack management
2. **S3 Generation Logic** (`s3/`) - Handles the actual S3 bucket file generation and GitHub commits

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Spacelift     │    │   S3 Generation  │    │   GitHub Repository │
│   Blueprint     │───▶│   Stack          │───▶│   (Generated .tf)   │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
```

## Features

- **Self-Service**: Users can create S3 buckets through Spacelift blueprints
- **GitOps Workflow**: Generated configurations are automatically committed to GitHub
- **Flexible Tagging**: Supports both simple (comma-separated) and complex (JSON) tag formats
- **Scheduled Cleanup**: Automatic resource cleanup after 1 hour (configurable)

### Using the Blueprint

Once deployed, users can create S3 buckets through the Spacelift blueprint interface with the following inputs:

- **bucket_name** (required): The name of the S3 bucket
- **bucket_tag_simple** (optional): Simple tags in format `key1=value1,key2=value2`
- **bucket_tags_complex** (optional): Complex tags as JSON object `{"key1":"value1","key2":"value2"}`

### Generated Output

The blueprint will:

1. Create a new Spacelift stack named `blueprint-bucket-{bucket_name}`
2. Generate a `.tf` file and commit that back into your GitHub repository

## Configuration

### Environment Variables

The blueprint automatically sets these environment variables:

- `TF_VAR_bucket_name`: The specified bucket name
- `TF_VAR_bucket_tags_simple`: Simple tag format
- `TF_VAR_bucket_tags_complex`: Complex tag format (JSON)
- `TF_VAR_username`: Name of the user who triggered the blueprint
- `TF_VAR_user_login`: Login of the user who triggered the blueprint

### Required Variables

For the S3 generation stack, ensure these variables are configured in Spacelift:

- `github_token`: GitHub personal access token
- `github_organization`: Your GitHub organization name
- `github_repository`: Target repository name (defaults to "s3")

## Generated S3 Configuration

The blueprint generates Terraform files using the [thoughtbot/terraform-s3-bucket](https://github.com/thoughtbot/terraform-s3-bucket) module:

```hcl
module my_bucket {
  source = "github.com/thoughtbot/terraform-s3-bucket?ref=v0.4.0"
  
  name = "my-bucket"
  tags = { 
    "Environment" = "production",
    "Owner" = "team-name",
  }
}
```

## Tagging Options

### Simple Tags

Use comma-separated key=value pairs:
```
Environment=production,Owner=team-name,Project=my-project
```

### Complex Tags

Use JSON format for more complex scenarios:
```json
{
  "Environment": "production",
  "Owner": "team-name",
  "Project": "my-project",
  "Cost-Center": "engineering"
}
```

## Automatic Cleanup

Stacks created by this blueprint are configured with automatic cleanup:

- **Cleanup Time**: 1 hour after creation
- **Delete Resources**: Disabled (set to `false`)
- **Purpose**: Cleans up the Spacelift stack, not the actual S3 bucket

## Customization

### Modifying the S3 Template

Edit `s3/s3.tftpl` to customize the generated Terraform configuration:

```hcl
module ${bucket_name} {
  source = "github.com/thoughtbot/terraform-s3-bucket?ref=v0.4.0"

  name = "${bucket_name}"
  tags = { 
    %{ for k, v in bucket_tags }
    "${k}" = "${v}",
    %{ endfor ~}
  }
  
  # Add additional configuration here
  versioning_enabled = true
  encryption_enabled = true
}
```

## Troubleshooting

### Common Issues

1. **GitHub Authentication**: Ensure the GitHub token has proper permissions to commit to the repository
2. **Worker Pool**: Verify the worker pool ID is correct for your environment
3. **AWS Integration**: Confirm the AWS integration name in the `spacelift_aws_integration` data source
