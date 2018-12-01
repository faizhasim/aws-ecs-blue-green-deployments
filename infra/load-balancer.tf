//module "alb" {
//  source                        = "terraform-aws-modules/alb/aws"
//  load_balancer_name            = "blue-green"
//  security_groups               = ["${module.http-sg.this_security_group_id}"]
////  log_bucket_name               = "logs-us-east-2-123456789012"
////  log_location_prefix           = "my-alb-logs"
//  subnets                       = "${module.vpc.private_subnets}}"
//  tags                          = "${map("Environment", "prod")}"
//  vpc_id                        = "${module.vpc.vpc_id}"
////  https_listeners               = "${list(map("certificate_arn", "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012", "port", 443))}"
////  https_listeners_count         = "1"
//  http_tcp_listeners            = "${list(map("port", "80", "protocol", "HTTP"))}"
//  http_tcp_listeners_count      = "1"
//  target_groups                 = "${list(map("name", "foo", "backend_protocol", "HTTP", "backend_port", "80"))}"
//  target_groups_count           = "1"
//}

module "http-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "http-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["${module.vpc.vpc_cidr_block}"]
}
