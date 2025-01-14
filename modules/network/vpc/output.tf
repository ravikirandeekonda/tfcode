# Description: Define output variables for the VPC module
# Type: Terraform (HCL)

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public_subnet[*].id
}

output "app_sg_id" {
  description = "Application security group ID"
  value       = aws_security_group.app_sg.id
}