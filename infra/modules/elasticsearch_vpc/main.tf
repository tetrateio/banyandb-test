
resource "aws_security_group" "es" {
  name        = "elasticsearch-${var.es_domain_name}"
  description = "Allow access from ${var.es_vpc_id}"
  vpc_id      = var.es_vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [var.es_vpc_cidr]
  }
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    dedicated_master_enabled = true
    dedicated_master_type    = var.es_master_instance_type
    dedicated_master_count   = var.es_master_count
    instance_count           = var.es_instance_count
    instance_type            = var.es_instance_type
    zone_awareness_enabled   = true

    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.es_per_instance_ebs_size
    volume_type = var.es_per_instance_ebs_type
  }

  vpc_options {
    subnet_ids         = var.es_vpc_subnet_ids
    security_group_ids = [aws_security_group.es.id]
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = var.es_domain_name
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain_name}/*"
    }
  ]
}
CONFIG
}

output "es_address" {
  value = aws_elasticsearch_domain.es.endpoint
}
