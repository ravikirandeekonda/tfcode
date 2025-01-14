
# The security group allows inbound traffic on port 22 (typically used for SSH).
# The security group also allows all outbound traffic.
# The security group is associated with the VPC.

resource "aws_security_group" "app_sg" {
  name = "app_sg"
  vpc_id = aws_vpc.vpc.id
  description = "Allow inbound traffic on port 22"
  tags = {
    Name = "cloudautomate-app-sg"
  }
}

resource "aws_security_group_rule" "ingress" {
  count = length(var.application_ports)
  type = "ingress"
  from_port = element(var.application_ports, count.index)
  to_port = element(var.application_ports, count.index)
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.app_sg.id
  description = "Allow SSH traffic"
}

resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.app_sg.id
  description = "Allow all outbound traffic"
}