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

variable "ebs_device_name" {
  description = "ebs device name"
  type = "string"
  default = "/dev/xvdf"
}

variable "ebs_mount_point" {
  description = "ebs mount point"
  type = "string"
  default = "/data"
}

variable "subnet_id" {
    description = "subnet id"
    type = "string"
    default = "subnet-f086f0fc"
}

variable "vpc_id" {
    description = "vpc id"
    type = "string"
    default = "vpc-34fa8c4d"
}

variable "volume_1_id" {
    description = "id of volume with flower data"
    type = "string"
    default = "vol-0b156a86ff2c6f1a2"
}

variable "hashed_notebook_password" {
    description = "hased_notebook_password for 'mydataflowernotebookpassword'"
    type = "string"
    default = "sha1:adc8323b5ab9:9865c35c8573307ec44b8eb98256e06dc57320ee"
}

variable "user" {
  description = "instance username"
  type = "string"
  default = "ubuntu"
}

variable "key_path" {
  description = "instance key"
  type = "string"
  default = "/Users/luiscunha/.ssh/ipython.pem"
}



