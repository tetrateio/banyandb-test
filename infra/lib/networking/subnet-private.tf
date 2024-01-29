
# Manage VPC private subnets
# create 3 (hardcoded below) private subnets and NAT gateways, 1 per AZ
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_secondary_cidr, 2, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.shared_tags,
    # Tag so k8s can discover in which subnets it can create internal load balancers
    {
      "Name"                            = "private-${count.index}"
      "kubernetes.io/role/internal-elb" = 1
  })

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]
}

# EIP for NAT GW
resource "aws_eip" "nat" {
  count  = 3
  domain = "vpc"
}

# NAT GW, allows private subnets to access the internets
resource "aws_nat_gateway" "nat" {
  count         = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.shared_tags,
    {
      Name = "nat-gw-${data.aws_availability_zones.available.names[count.index]}"
  })
}

# Public network route table
resource "aws_route_table" "private" {
  count  = 3
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(
    local.shared_tags,
    {
      Name = "private-route-table-${data.aws_availability_zones.available.names[count.index]}"
  })
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
}

# Network <> route table association
resource "aws_route_table_association" "private_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
