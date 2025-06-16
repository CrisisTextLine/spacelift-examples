resource "null_resource" "this" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "env"
  }
}

variable "variable_1" {
  type        = string
  description = "This is a variable that will be used in the child stack."
  default     = "default_value"
}

output "variable_1" {
  value = var.variable_1
}

variable "variable_2" {
  type        = string
  description = "This is another variable that will be used in the child stack."
  default     = "another_default_value"
}
output "variable_2" {
  value = var.variable_2
}