resource "null_resource" "this" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "env"
  }
}