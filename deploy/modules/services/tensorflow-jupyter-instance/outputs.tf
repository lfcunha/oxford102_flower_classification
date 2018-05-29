# render the user data template
resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > user_data_init_script_output.sh <<EOL\n${data.template_file.instance_init.rendered}\nEOL"
  }
}

output "public_ip" {
  value = "${aws_instance.notebook.public_ip}"
}

# to use for adding rules to the security group outside the model
output "instance_security_group_id" {
  value = "${aws_security_group.instance.id}"
}

