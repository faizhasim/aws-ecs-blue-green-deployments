variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-southeast-1"
}

variable "route53_zone_id" {
  default = "Z26GY0MAFBIOJQ"
}

variable "green_docker_image_tag" {
//  default = "latest"
}

variable "blue_docker_image_tag" {
//  default = "latest"
}
