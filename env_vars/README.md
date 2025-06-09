# Spacelift Environment Variables with YAML

This example demonstrates how to manage Spacelift environment variables using a YAML configuration file with the Spacelift Terraform provider.

## Overview

Instead of defining environment variables individually in Terraform, this approach uses a centralized YAML file to define variables for multiple stacks, making it easier to manage and maintain environment configurations.

## Structure

- `main.tf` - Main Terraform configuration that reads the YAML file and creates Spacelift resources
- `vars.yaml` - YAML file containing environment variable definitions for each stack
- `child_stack/main.tf` - Example child stack configuration
- `opentofu.tf` - OpenTofu provider configuration

## How it Works

1. **YAML Configuration**: Environment variables are defined in `vars.yaml` using the following structure:
   ```yaml
   stack-id:
     - name: VARIABLE_NAME
       value: variable_value
       sensitive: false
   ```

2. **Terraform Processing**: The main Terraform configuration:
   - Reads and parses the YAML file using `yamldecode(file("vars.yaml"))`
   - Flattens the structure into a list of variables with their associated stack IDs
   - Creates `spacelift_environment_variable` resources for each variable

3. **Stack Association**: Variables are automatically associated with their respective stacks based on the stack ids defined in the YAML file.

## Example Configuration

### vars.yaml
```yaml
env-var-yaml-1:
  - name: KUBECONFIG
    value: /home/joey/.kube/config
    sensitive: false

env-var-yaml-2:
  - name: AWS_PROFILE
    value: test
    sensitive: false
  - name: MY_AWESOME_SECRET
    value: HelloWorld
    sensitive: true
```

The above configuration will create the following in a plan:

```ansi
# spacelift_environment_variable.this["env-var-yaml-1_KUBECONFIG"] will be created
  + resource "spacelift_environment_variable" "this" {
      + checksum   = (known after apply)
      + id         = (known after apply)
      + name       = "KUBECONFIG"
      + stack_id   = "env-var-yaml-1"
      + value      = (sensitive value)
      + write_only = false
    }

  # spacelift_environment_variable.this["env-var-yaml-2_AWS_PROFILE"] will be created
  + resource "spacelift_environment_variable" "this" {
      + checksum   = (known after apply)
      + id         = (known after apply)
      + name       = "AWS_PROFILE"
      + stack_id   = "env-var-yaml-2"
      + value      = (sensitive value)
      + write_only = false
    }

  # spacelift_environment_variable.this["env-var-yaml-2_MY_AWESOME_SECRET"] will be created
  + resource "spacelift_environment_variable" "this" {
      + checksum   = (known after apply)
      + id         = (known after apply)
      + name       = "MY_AWESOME_SECRET"
      + stack_id   = "env-var-yaml-2"
      + value      = (sensitive value)
      + write_only = true
    }
```