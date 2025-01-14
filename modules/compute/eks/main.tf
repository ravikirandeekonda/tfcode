# Creates an Amazon EKS (Elastic Kubernetes Service) cluster.
# The EKS cluster is associated with the specified IAM role, VPC, and subnets.

resource "aws_eks_cluster" "appeks" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  version                   = var.eks_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }
  tags = {
    Name = var.cluster_name
  }

}