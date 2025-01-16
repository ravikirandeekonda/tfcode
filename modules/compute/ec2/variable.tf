variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0c2b8ca1dad447f8a"
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name to use for the EC2 instance"
  type        = string
  default     = "cloudautomate"
}

variable "subnet_id" {
  description = "The subnet ID to use for the EC2 instance"
  type        = list(string)
  default     = ["subnet-0b3b3b3b3b3b3b3b3", "subnet-0b3b3b3b3b3b3b3b3"]
}

variable "name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "cloudautomate-instance"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to use for the EC2 instance"
  type        = string
  default     = "EC2SSMRole"
}

variable "app_ing_ports" {
  description = "The list of ingress ports to allow traffic to the application"
  type        = list(number)
  default     = [80, 443]
}

variable "vpc_id" {
  description = "The VPC ID to use for the EC2 instance"
  type        = string
  default     = "vpc-0b3b3b3b3b3b3b3b3"

}

variable "app_sg_id" {
  description = "The security group ID to use for the EC2 instance"
  type        = string
  default     = "sg-0b3b3b3b3b3b3b3b3"
}