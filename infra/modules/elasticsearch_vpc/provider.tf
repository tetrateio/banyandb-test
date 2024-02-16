# Copyright (c) Tetrate, Inc 2024 All Rights Reserved.

provider "aws" {
  region = var.es_region
}

# Declare the AWS AZ data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
