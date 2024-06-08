resource "aws_network_interface" "asav_private_interface" {
  subnet_id         = aws_subnet.Private_Subnet_Security_VPC.id
  private_ips       = ["10.100.100.100"]
  source_dest_check = false

  tags = {
    Name = "${local.cisco_asav_name}PrivateInterface"
  }
}


resource "aws_subnet" "Private_Subnet_Security_VPC" {
  vpc_id            = aws_vpc.Security_VPC.id
  cidr_block        = var.private_Subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private_Subnet_Security_VPC"
  }
}