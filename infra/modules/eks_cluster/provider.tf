
# AWS AZ enable
data "aws_availability_zones" "available" {
  state = "available"
}

# TODO(denis) make it a config variable written in ~stone~ git.
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
