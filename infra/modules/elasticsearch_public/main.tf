
resource "aws_security_group" "es" {
  name = "es-${var.es_domain_name}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "es" {
  description             = "KMS key for ES domain ${var.es_domain_name}"
  deletion_window_in_days = 10
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  cluster_config {
    dedicated_master_enabled = var.es_master_enabled
    dedicated_master_type    = var.es_master_instance_type
    dedicated_master_count   = var.es_master_count
    instance_count           = var.es_instance_count
    instance_type            = var.es_instance_type
    zone_awareness_enabled   = var.es_master_enabled && var.es_instance_count > 1

    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.es_per_instance_ebs_size
    volume_type = var.es_per_instance_ebs_type
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = var.es_domain_name
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.es_username
      master_user_password = var.es_password
    }
  }

  # Required for authz to be enabled
  node_to_node_encryption {
    enabled = true
  }
  encrypt_at_rest {
    enabled = true
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
