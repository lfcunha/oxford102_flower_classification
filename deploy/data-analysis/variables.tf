variable "aws_region" {
    description = "EC2 Region for the VPC"
    type = "string"
    default = "us-east-1"
}


variable "vpc_id" {
    description = "vpc id"
    type = "string"
    default = "vpc-34fa8c4d"
}

variable "subnet_id" {
    description = "subnet id"
    type = "string"
    default = "subnet-f086f0fc"
}