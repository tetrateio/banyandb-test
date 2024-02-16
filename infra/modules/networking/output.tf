output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private[0].id,
    aws_subnet.private[1].id,
    aws_subnet.private[2].id
  ]
}

output "private_subnet_cidrs" {
  value = [
    aws_subnet.private[0].cidr_block,
    aws_subnet.private[1].cidr_block,
    aws_subnet.private[2].cidr_block
  ]
}

output "private_subnet_ids_az" {
  value = {
    (aws_subnet.private[0].availability_zone) = aws_subnet.private[0].id
    (aws_subnet.private[1].availability_zone) = aws_subnet.private[1].id
    (aws_subnet.private[2].availability_zone) = aws_subnet.private[2].id
  }
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id,
    aws_subnet.public[2].id
  ]
}

output "public_subnet_cidrs" {
  value = [
    aws_subnet.public[0].cidr_block,
    aws_subnet.public[1].cidr_block,
    aws_subnet.public[2].cidr_block
  ]
}

output "public_subnet_ids_az" {
  value = {
    (aws_subnet.public[0].availability_zone) = aws_subnet.public[0].id
    (aws_subnet.public[1].availability_zone) = aws_subnet.public[1].id
    (aws_subnet.public[2].availability_zone) = aws_subnet.public[2].id
  }
}
