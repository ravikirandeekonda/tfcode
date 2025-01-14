# This module creates a VPC with the specified CIDR block and subnets.
module "vpc_module" {
  source               = "../modules/network/vpc"
  vpc_cidr             = "172.16.0.0/16"
  name                 = "cloudautomate"
  public_subnet_cidr   = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnet_cidr  = ["172.16.2.0/24", "172.16.3.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  enable_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}

module "ec2mod" {
  source        = "../modules/compute/ec2"
  instance_type = var.instance_type
  ami           = var.ami
  key_name      = var.key_name
  subnet_id     = module.vpc_module.public_subnet_ids[0]
  app_sg_id     = module.vpc_module.app_sg_id
  depends_on    = [module.vpc_module]
}

module "eks_module" {
  source = "../modules/compute/eks"
  cluster_name = var.cluster_name
  eks_role_arn = var.eks_role_arn
  subnet_ids = [module.vpc_module.public_subnet_ids[0], module.vpc_module.public_subnet_ids[1]]
  eks_version = "1.31"
  kms_key_arn = var.eks_role_arn
  depends_on = [module.vpc_module]
}

# This module creates an S3 bucket with the specified configuration.
/*
module "s3module" {
  source = "../modules/storage/s3"
  bucket_name = "cloudautomate-bucket"
  acl = "private"
  versioning = true
  tags = {
    Name = "cloudautomate-bucket"
  }
  
}
*/