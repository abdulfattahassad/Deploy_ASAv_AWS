
resource "aws_subnet" "MGMT_Subnet_Security_VPC" {
  vpc_id            = aws_vpc.Security_VPC.id
  cidr_block        = var.MGMT_Subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private_Subnet_Security_VPC"
  }
}


resource "aws_network_interface" "asav_mgmt_interface" {
  subnet_id         = aws_subnet.MGMT_Subnet_Security_VPC.id
  source_dest_check = false

  tags = {
    Name = "${local.cisco_asav_name}mgmt_interface"
  }
}






