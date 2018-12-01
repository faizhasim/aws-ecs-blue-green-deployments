provider "aws" {
  region = "${var.aws_region}"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
