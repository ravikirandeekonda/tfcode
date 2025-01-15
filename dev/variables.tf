variable "iam_instance_profile" {
  description = "The IAM instance profile to use for the EC2 instance"
  type        = string
  default     = "EC2SSMRole"
}

variable "instance_profile_name" {
  description = "The name of the instance profile to use for the EC2 instance"
  type        = string
  default     = "cloudautomate-instance-profile"
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-1"

}

variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-053b12d3152c0cc71"
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t3a.medium"
}

variable "key_name" {
  description = "The key pair name to use for the EC2 instance"
  type        = string
  default     = "sanbox-mumbai-keypair"
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  type        = string
  default     = "arn:aws:iam::724772072892:role/EKSClusterRole"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "cloudautomate-eks"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for the EKS cluster"
  type        = string
  default     = "arn:aws:kms:ap-south-1:724772072892:key/76ea72cc-eb60-4864-a10e-7a1c9e45d663"
}

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}