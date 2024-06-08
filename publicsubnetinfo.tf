resource "aws_subnet" "aws_public_subnet" {
  vpc_id            = aws_vpc.Security_VPC.id
  cidr_block        = var.public_Subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "ASAv_AwsPublicSubnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Security_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

# Assoicate Public Route Table with Public Subnet
resource "aws_route_table_association" "Public_Routing_Assoicataion" {
  subnet_id      = aws_subnet.aws_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}




# Configure Public Securty list- Network ACL - Public Subnet
resource "aws_network_acl" "sl_public_subnet" {
  vpc_id = aws_vpc.Security_VPC.id

  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "SL_Public_Subnet"
  }
}

# Assoicate SL-Public-Subnet  with Public Subnet
########################################

resource "aws_network_acl_association" "sL_sublic_subnet_association" {
  network_acl_id = aws_network_acl.sl_public_subnet.id
  subnet_id      = aws_subnet.aws_public_subnet.id
}

################################################################







resource "aws_network_interface" "asav_public_interface" {
  subnet_id         = aws_subnet.aws_public_subnet.id
  source_dest_check = false

  tags = {
    Name = "${local.cisco_asav_name}PublicInterface"
  }
}


resource "aws_eip" "cisco_asav_elastic_public_ip" {
 domain = "vpc"
 network_interface         = aws_network_interface.asav_public_interface.id
 
depends_on = [
  aws_internet_gateway.IGW
  ]
}

output "public_ASAv_IP_address" {
  value = aws_eip.cisco_asav_elastic_public_ip.public_ip
}




