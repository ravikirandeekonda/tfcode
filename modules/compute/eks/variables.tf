variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "cloudautomate-eks"
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  type        = string
  default     = "arn:aws:iam::724772072892:role/EKSClusterRole"
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["subnet-0b3b3b3b3b3b3b3b3", "subnet-0b3b3b3b3b3b3b3b4"]
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for the EKS cluster"
  type        = string
  default     = "arn:aws:kms:ap-south-1:724772072892:key/76ea72cc-eb60-4864-a10e-7a1c9e45d663"
}