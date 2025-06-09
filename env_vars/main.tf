terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "spacelift" {}

locals {
  env_vars = flatten([
    for stack_id, vars in yamldecode(file("${path.module}/vars.yaml")) : [
      for variable in vars : {
        stack_id  = stack_id
        name      = variable.name
        value     = variable.value
        sensitive = variable.sensitive
      }
    ]
  ])
}

resource "spacelift_stack" "stack_1" {
  name         = "env var yaml 1"
  branch       = "main"
  repository   = "examples"
  project_root = "env_vars/child_stack"
  labels       = ["example"]
}

resource "spacelift_stack" "stack_2" {
  name         = "env var yaml 2"
  branch       = "main"
  repository   = "examples"
  project_root = "env_vars/child_stack"
  labels       = ["example"]
}

resource "spacelift_environment_variable" "this" {
  for_each = local.env_vars

  stack_id   = each.value.stack_id
  name       = each.value.name
  value      = each.value.value
  write_only = each.value.sensitive

  depends_on = [spacelift_stack.stack_1, spacelift_stack.stack_2]
}