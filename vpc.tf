resource "aws_eip" "ovpn-eip" {
  count = "${var.eip_count}"
  vpc = true

  tags = {
    Name = "asg-pool"
  }
}


resource "aws_vpc" "ovpn-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "ovpn-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"

  tags = {
    Name = "ovpn-gateway"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "public-1a"
  }

}

resource "aws_subnet" "public-1b" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "public-1b"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "private-1a"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "private-1b"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.ovpn-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "public-1a" {
  subnet_id = "${aws_subnet.public-1a.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "public-1b" {
  subnet_id = "${aws_subnet.public-1b.id}"
  route_table_id = "${aws_route_table.public-route.id}"

}
