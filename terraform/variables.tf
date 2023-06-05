variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region for terraform resources"
}

variable "vpc_cidr" {}

variable "basename" {
   description = "Prefix used for all resources names"
}

variable "subnet_list" {
   type = map
}