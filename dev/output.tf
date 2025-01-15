output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc_module.vpc_id
}

output "instance-public-ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2mod.instance_public_ip
}