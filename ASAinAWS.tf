locals {
  cisco_asav_name       = "CiscoASAv"  # Just for fun, name your ASAv anything you'd like!
  ssh_key_name          = "cisco_asav_keypair"  # Update only if you've created an SSH key with a different name than cisco_asav_keypair
}

#   10.100.100.0	10.100.100.1 -   10.100.100.62	10.100.100.63  -- MGMT
#	10.100.100.64	10.100.100.65 -  10.100.100.126	10.100.100.127 --- Private
#	10.100.100.128	10.100.100.129 - 10.100.100.190	10.100.100.191=== Public
#	10.100.100.192  FREE

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "Security_VPC" {
  cidr_block = "10.100.100.0/24"

  tags = {
    Name = "Security VPC"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Security_VPC.id

  tags = {
    Name = "Aws_IGW"
  }
}

# Build the ASAv
resource "aws_instance" "cisco_asav" {
  # This AMI is only valid in us-east-1 region, with this specific instance type
  ami           = "ami-01b0bfec54ba93d12"
  instance_type = "c4.large"
  key_name      = local.ssh_key_name

  
  network_interface {
    network_interface_id = aws_network_interface.asav_public_interface.id
    device_index         = 0
  }

 network_interface {
    network_interface_id = aws_network_interface.asav_private_interface.id
    device_index         = 1
  }

 network_interface {
    network_interface_id = aws_network_interface.asav_mgmt_interface.id
    device_index         = 2
  }

  
  tags = {
    Name = local.cisco_asav_name
  }
}
