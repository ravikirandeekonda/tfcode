# Creates an AWS Virtual Private Cloud (VPC) with the specified CIDR block.
# The VPC is tagged with a name derived from the 'name' variable.
#
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Creates public subnets within the specified VPC.
# The number of subnets created is determined by the length of the public_subnet_cidr variable.
# Each subnet is assigned a CIDR block and an availability zone from the respective lists.
# The subnets are tagged with a name that includes the index of the subnet.
# Public subnets are configured to allow instances to receive public IP addresses.
#
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-subnet-${element(var.availability_zones, count.index)}"
  }
  depends_on = [ aws_vpc.vpc ]
}

# Creates multiple private subnets within a VPC.
# The number of subnets created is determined by the length of the private_subnet_cidr variable.
# Each subnet is assigned a CIDR block and an availability zone from the respective lists.
# The subnets are tagged with a name that includes the index of the subnet.
# Private subnets are configured to not allow instances to receive public IP addresses.
#
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.name}-private-subnet-${element(var.availability_zones, count.index)}"
  }
  depends_on = [ aws_vpc.vpc ]
}

# Creates an AWS Internet Gateway resource.
# The Internet Gateway is attached to the specified VPC and tagged with a name that includes the 'name' variable.
#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
  depends_on = [ aws_vpc.vpc ]
}

# Creates a public route table for the specified VPC.
# The route table is associated with the public subnets created earlier.
# The route table includes a default route to the Internet Gateway.
#
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.name}-public-route-table"
  }
  depends_on = [ aws_internet_gateway.igw, aws_vpc.vpc ]
}

# Associates the public route table with the public subnets created earlier.
#
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  depends_on     = [ aws_subnet.public_subnet, aws_route_table.public_route_table ]
}

# Creates a NAT Gateway resource in the specified VPC.
# The NAT Gateway is associated with an Elastic IP address and a public subnet.
# The NAT Gateway is tagged with a name that includes the 'name' variable.
# The NAT Gateway is only created if the 'enable_nat_gateway' variable is set to true.
#
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.name}-nat-gateway"
  }
  depends_on = [ aws_subnet.public_subnet, aws_eip.nat_eip ]
}

# Creates an Elastic IP address resource for the NAT Gateway.
# The Elastic IP address is associated with the specified VPC and tagged with a name that includes the 'name' variable.
#
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.name}-nat-eip"
  }
  depends_on = [ aws_vpc.vpc ]
}

# Creates a private route table for the specified VPC.
# The route table is associated with the private subnets created earlier.
# The route table includes a default route to the NAT Gateway.
#
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }
  tags = {
    Name = "${var.name}-private-route-table"
  }
  depends_on = [ aws_nat_gateway.nat_gateway, aws_vpc.vpc ]
}

# Associates the private route table with the private subnets created earlier.
#
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
  depends_on     = [ aws_subnet.private_subnet, aws_route_table.private_route_table ]
}


