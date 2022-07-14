#################### Provider ############################
provider "aws" {
    access_key = "${var.myaccess_key}"
    secret_key = "${var.mysecret_key}"
    region = "${var.myregion}"
}

##################### Resorces ###########################
resource "aws_vpc" "myVPC" {
  cidr_block = "192.154.0.0/16"
   tags = {
     "Name" = "myVPC"
   }
}

resource "aws_subnet" "mypublicsubnet" {
    cidr_block = "192.154.1.0/"
    availability_zone = "us-west-2a"
    vpc_id = aws_vpc.myVPC.id
     tags = {
       "Name" = "mypublicsubnet"
     }
}

resource "aws_route_table" "myPublicRouteTable" {
   vpc_id = aws_vpc.myVPC.id
   tags = {
     "Name" = "myPublicRoute"
   }
}

resource "aws_route_table_association" "myPublicRouteAss" {
    subnet_id = aws_subnet.mypublicsubnet.id
    route_table_id = aws_route_table.myPublicRouteTable.id
  
}

resource "aws_egress_only_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
}
resource "aws_route" "myPublicRoute" {
  route_table_id              = aws_route_table.myPublicRouteTable.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.myIGW.id

}
###################### outputs ##########################
output "myVPCID" {value = aws_vpc.myVPC.id}
output "myPublicSubnetID" {value = aws_subnet.mypublicsubnet.id}
output "myRoutetableID" {value = aws_route_table.myPublicRouteTable.id}
output "myIGW" {value = aws_egress_only_internet_gateway.myIGW.id}