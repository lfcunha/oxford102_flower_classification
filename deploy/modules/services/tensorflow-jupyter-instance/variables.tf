variable "aws_region" {
    description = "EC2 Region for the VPC"
    type = "string"
    default = "us-east-1"
}

variable "availability_zone" {
  description = "availability zone"
  type = "string"
  default = "us-east-1f"
}

variable "aws_amis" {
    description = "AMI to use"
    type = "map"
    default = {
        us-east-1 = "ami-00fc7481b84be120b"
  }
}

# Elastic ip
variable "ip" {
  description = "elastic ip to use"
  type = "string"
  default = "54.146.243.156"
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
}

variable "vpc_id" {
    description = "vpc id"
    type = "string"
}

variable "volume_1_id" {
    description = "id of volume with flower data"
    type = "string"
}

variable "hashed_notebook_password" {
    description = "hased_notebook_password for 'mydataflowernotebookpassword'"
    type = "string"
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

variable "instance_iam_role_name" {
  description = "instance iam role name"
  type = "string"
  default = "LuisC"
}

variable "instance_externally_accessible" {
  description = "create public ip?"
  type = "string"
  default = "true"
}

variable "instance_key_name" {
  description = "ssh key name"
  type = "string"
  default = "ipython"
}

variable "instance_type" {
  description = "instance type"
  type = "string"
  #default =  "p3.2xlarge" #"p2.xlarge"  #p3.2xlarge  #"t2.large"
  default =  "p2.xlarge"
  #default =  "t2.large"
}








