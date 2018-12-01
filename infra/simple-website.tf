//module "ecs-service" {
//  source = "git::https://github.com/egarbi/terraform-aws-ecs-service"
//
//  name                  = "simple"
//  environment           = "prod"
//  desired_count         = "1"
//  cluster               = "simple-prod"
//  vpc_id                = "${module.vpc.vpc_id}}"
//  zone_id               = "${var.route53_zone_id}}"
//  iam_role              = "${module.ecs-service.task_role_arn}}"
//  rule_priority         = "10"
//  alb_listener          = "${module.alb.http_tcp_listener_arns[0]}"
//  alb_zone_id           = "${module.alb.load_balancer_zone_id}"
//  alb_dns_name          = "${module.alb.dns_name}"
//  container_definitions = "${file("container_definitions.json")}"
//}
locals {
  container_name = "simple-website"
  container_port = "80"
}

//module "ec2-iam-role" {
//  source = "git::https://github.com/tkskwn/terraform-aws-ec2-iam-role"
//  name   = "simple-service-iam-role"
//
//  policy_arn = [
//    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
//    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
//  ]
//}

resource "aws_ecs_cluster" "main" {
  name = "simple-website"
}

data "template_file" "simple-website" {
  template = "${file("${path.root}/task-definition/simple-website.json")}"

  vars {
    container_name   = "${local.container_name}"
    container_port   = "${local.container_port}"
//    log_group_name   = "${aws_cloudwatch_log_group.log_group.name}"
//    log_group_region = "${var.aws_region}"
//    log_group_prefix = "simple-website-040"
  }
}

module "simple-website" {
  source  = "npalm/ecs-service/aws"

  service_name          = "simple-website"
  service_desired_count = 1

  environment = "prod"

  vpc_id       = "${module.vpc.vpc_id}"
  vpc_cidr     = "${module.vpc.vpc_cidr_block}"
  lb_subnetids = "${module.vpc.public_subnets}"

  ecs_cluster_id = "${aws_ecs_cluster.main.id}"

  lb_internal = false

  task_definition = "${data.template_file.simple-website.rendered}"
  task_cpu        = "256"
  task_memory     = "512"

  service_launch_type = "FARGATE"

  awsvpc_task_execution_role_arn = "${aws_iam_role.ecs-iam-role.arn}"
  awsvpc_service_security_groups = ["${module.http-sg.this_security_group_id}"]
  awsvpc_service_subnetids       = "${module.vpc.private_subnets}"

  lb_target_group = {
    container_name = "${local.container_name}"
    container_port = "${local.container_port}"
  }

  lb_listener = {
    port     = 80
    protocol = "HTTP"
  }
}
