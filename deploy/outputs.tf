output "public_ip" {
  value = "${aws_instance.notebook.public_ip}"
}

resource "null_resource" "export_rendered_template" {
  provisioner "local-exec" {
    command = "cat > user_data_init_script_output.sh <<EOL\n${data.template_file.instance_init.rendered}\nEOL"
  }
}