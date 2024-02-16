
# Public subnet
resource "aws_subnet" "public" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.shared_tags,
    # Tag so that k8s can discover subnets in which it can create public load balancers
    {
      Name                     = "public-${count.index}"
      "kubernetes.io/role/elb" = 1
  })
}

# Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.shared_tags,
    {
      Name = "internet-gw-${var.vpc_name}"
  })
}

# Public network route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    local.shared_tags,
    {
      Name = "public-route-table-${var.vpc_name}"
  })
}

# Network <> route table association
resource "aws_route_table_association" "public_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
