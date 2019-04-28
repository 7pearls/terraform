# Internet VPC
resource "aws_vpc" "main" {
    cidr_block = "10.192.17.0/26"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "main"
    }
}


# Subnets
resource "aws_subnet" "main-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.192.17.0/27"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1a"

    tags {
        Name = "main-public-1"
    }
}

resource "aws_subnet" "main-private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.192.17.32/27"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1a"

    tags {
        Name = "main-private-1"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC-Attachment" {
  vpc_id                                          = "${aws_vpc.main.id}"
   ##value from shared transit gateway in another AWS account.
  transit_gateway_id                       = "tgw-05d8b7738ac0c2a02"
  subnet_ids                                    = ["${aws_subnet.main-public-1.id}"]
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
 tags {
        Name = "tgw-main"
    }

}


# Internet GW
#resource "aws_internet_gateway" "main-gw" {
#    vpc_id = "${aws_vpc.main.id}"
#
#    tags {
#        Name = "main"
#    }
#}

# route tables
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        transit_gateway_id = "tgw-05d8b7738ac0c2a02"
    }

    tags {
        Name = "main-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
