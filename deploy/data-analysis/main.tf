# store tfstate file in s3 instead of locally (https://www.terraform.io/docs/backends/types/s3.html)
terraform {
  backend "s3" {
    bucket = "lfcunha-terraform"
    key    = "jupyter-notebook-flower_comp/global/.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "${var.aws_region}"
}


module "dataanalysis_instance" {
  source = "../modules/services/tensorflow-jupyter-instance"
  #source = "git::git@github.com:foo/modules.git//webserver-cluster?ref=v0.0.1"  # use a tagged git repo


  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
  volume_1_id = "vol-0b156a86ff2c6f1a2"
  hashed_notebook_password = "sha1:adc8323b5ab9:9865c35c8573307ec44b8eb98256e06dc57320ee"
}

# expose an additional port in the security group defined in the tensorflow-jupyter-instance module
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = "${module.dataanalysis_instance.instance_security_group_id}"

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}