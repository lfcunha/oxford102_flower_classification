variable "aws_region" {
    description = "EC2 Region for the VPC"
    type = "string"
    default = "us-east-1"
}

variable "aws_amis" {
    description = "AMI to use"
    type = "map"
    default = {
        us-east-1 = "ami-dff741a0"
  }
}

variable "efs_host" {
    description = "efs ip or dns"
    type = "string"
    default = "10.0.0.71"
}

variable "efs_mount_point" {
    description = "efs mount point"
    type = "string"
    default = "/efs"
}

variable "subnet_id" {
    description = "subnet id"
    type = "string"
    default = "subnet-f086f0fc"
}
