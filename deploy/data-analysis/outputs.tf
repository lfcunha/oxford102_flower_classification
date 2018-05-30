output "public_ip" {
  value = "${module.dataanalysis_instance.public_ip}"
}

# to use for adding rules to the security group outside the model
output "instance_security_group_id" {
  value = "${module.dataanalysis_instance.instance_security_group_id}"
}
