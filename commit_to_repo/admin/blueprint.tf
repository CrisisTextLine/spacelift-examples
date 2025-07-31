locals {
  # read blueprint yaml to a map
  blueprint = yamldecode(file("${path.module}/blueprint.yaml"))

  # add a new input for tag name
  pr_blueprint = merge(
    local.blueprint,
    {
      inputs = concat(
        local.blueprint.inputs,
        [
          {
            id : "branch_name",
            name : "Branch Name",
            default : "main",
          }
        ]
      ),
      stack = merge(
        local.blueprint.stack,
        {
          environment = merge(
            local.blueprint.stack.environment,
            {
              variables = concat(
                local.blueprint.stack.environment.variables,
                [
                  {
                    name : "TF_VAR_branch",
                    value : "$${{inputs.branch_name}}",
                  }
                ]
              )
            }
          )
        }
      ),
    }
  )
}

resource "spacelift_blueprint" "no_pr_blueprint" {
  name     = "Create S3 Bucket (no PR)"
  space    = data.spacelift_current_space.current.id
  state    = "PUBLISHED"
  template = local.blueprint
}

resource "spacelift_blueprint" "pr_blueprint" {
  name     = "Create S3 Bucket (with PR)"
  space    = data.spacelift_current_space.current.id
  state    = "PUBLISHED"
  template = local.pr_blueprint
}