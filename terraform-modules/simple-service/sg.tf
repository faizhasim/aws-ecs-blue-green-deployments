module "http-sg" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "${var.service-name}-http-sg"
  description         = "Security group for web-server with HTTP ports open within VPC"
  vpc_id              = "${var.vpc_id}"
  ingress_cidr_blocks = ["${var.vpc_cidr}"]
}
