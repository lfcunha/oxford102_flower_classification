provider "aws" {
  region = "${var.aws_region}"
}


resource "aws_instance" "example" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.medium"
  availability_zone = "us-east-1f"
  key_name = "ipython"

  subnet_id= "${var.subnet_id}"
  #security_groups = [ "${var.security_groups}" ]
  user_data = "${element(data.template_file.instance_init.*.rendered, 0)}"


  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  tags {
    Name = "deeplearning-cpu-flowercompetition"
  }
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#template files to set EC2 user data
data "template_file" "instance_init" {
  template = "${file("init.tpl")}"
  vars {
    ebs_device_name = "/dev/xvdf"
    ebs_mount_point = "/data"
    efs_host = "${var.efs_host}"
    efs_mount_point = "${var.efs_mount_point}"
  }
}