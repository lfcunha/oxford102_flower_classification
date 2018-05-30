resource "aws_instance" "notebook" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.instance_key_name}"
  subnet_id= "${var.subnet_id}"
  #security_groups = [ "${var.security_groups}" ]
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  iam_instance_profile = "${var.instance_iam_role_name}"
  associate_public_ip_address = "${var.instance_externally_accessible}"
  user_data = "${element(data.template_file.instance_init.*.rendered, 0)}"

//  this requires it to also be set in every dependecy. Also, will it not detach the volume first? if no, it's a problem
//  lifecycle {
//    create_before_destroy = true
//  }


  # upload certificate for jupyter notebook ssl
  provisioner "file" {
    source      = "./data/mykey.key"
    destination = "/home/ubuntu/mykey.key"

      connection {
        user = "${var.user}"
        type = "ssh"
        host = "${self.public_ip}"
        private_key = "${file(var.key_path)}"
        agent = false
    }
  }

  provisioner "file" {
    source      = "./data/mycert.pem"
    destination = "/home/ubuntu/mycert.pem"

      connection {
        user = "${var.user}"
        type = "ssh"
        host = "${self.public_ip}"
        private_key = "${file(var.key_path)}"
        agent = false
    }
  }

//  provisioner "remote-exec" {
//        inline = [
//            #"sudo mv /home/ubuntu/mycert.pem  /etc/mycert.pem",
//            #"sudo mv /home/ubuntu/mykey.key  /etc/mykey.key",
//            "export PATH=/home/ubuntu/anaconda3/bin:$PATH",
//            "sudo mount -a"
//        ]
//
//        connection {
//        user = "${var.user}"
//        type = "ssh"
//        host = "${self.public_ip}"
//        private_key = "${file(var.key_path)}"
//        agent = false
//    }
//    }
//
//    provisioner "remote-exec" {
//        scripts = [
//            "${path.module}/scripts/${var.platform}/install.sh",
//            "${path.module}/scripts/${var.platform}/server.sh",
//            "${path.module}/scripts/${var.platform}/service.sh",
//        ]
//    }

  tags {
    Name = "deeplearning-cpu-flowercompetition"
  }
}

# Attach Data Volume
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdf"
  volume_id = "${var.volume_1_id}"
  instance_id = "${aws_instance.notebook.id}"

  skip_destroy = true
  #force_detach = true
}

# Create security group in existing VPC
resource "aws_security_group" "instance" {
  name = "instance"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "allow_jupyter_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 8888
  to_port     = 8888
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["24.90.154.168/32"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


#template files to set EC2 user data
data "template_file" "instance_init" {
  template = "${file("${path.module}/user-data.tpl")}"
  vars {
    ebs_device_name = "${var.ebs_device_name}"
    ebs_mount_point = "${var.ebs_mount_point}"
    efs_host = "${var.efs_host}"
    efs_mount_point = "${var.efs_mount_point}"
    hashed_notebook_password = "${var.hashed_notebook_password}"
  }
}

