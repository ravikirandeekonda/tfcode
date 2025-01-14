resource "aws_instance" "app_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  user_data            = file("D:/DATA/Cloud4c/My_Projects/AWS/AWS-BUILD/2025/Trainings/tfcode/modules/compute/ec2/userdata.sh")
  disable_api_termination = true
  tags = {
    Name = var.name
  }
  vpc_security_group_ids = [var.app_sg_id]

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false
  }

  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false
  }
}