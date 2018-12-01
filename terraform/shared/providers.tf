provider "aws" {
  region = "${var.aws_region}"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

terraform {
  backend "s3" {
    bucket = "com.faizhasim.terraform"
    key = "aws-ecs-blue-green-deployments/shared.terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}
