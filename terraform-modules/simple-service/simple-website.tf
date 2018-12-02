locals {
  container_port = "80"
}

resource "aws_ecs_cluster" "simple-website" {
  name = "${var.service-name}"
}

data "template_file" "simple-website" {
  template = "${file("${path.module}/task-definition/simple-website.json")}"

  vars {
    container_name   = "${var.service-name}"
    container_port   = "${local.container_port}"
    image_version    = "${var.docker_image_tag}"
  }
}

module "simple-website" {
  source = "git::https://github.com/faizhasim/terraform-aws-ecs-service.git?ref=output-alb-zone-id"

  service_name          = "${var.service-name}"
  service_desired_count = 2

  environment = "prod"

  vpc_id       = "${var.vpc_id}"
  vpc_cidr     = "${var.vpc_cidr}"
  lb_subnetids = "${var.lb_subnetids}"

  ecs_cluster_id = "${aws_ecs_cluster.simple-website.id}"

  lb_internal = false

  task_definition = "${data.template_file.simple-website.rendered}"
  task_cpu        = "256"
  task_memory     = "512"

  service_launch_type = "FARGATE"

  awsvpc_task_execution_role_arn = "${var.awsvpc_task_execution_role_arn}"
  awsvpc_service_security_groups = ["${module.http-sg.this_security_group_id}"]
  awsvpc_service_subnetids       = "${var.awsvpc_service_subnetids}"

  lb_target_group = {
    container_name = "${var.service-name}"
    container_port = "${local.container_port}"
  }

  lb_listener = {
    port     = 80
    protocol = "HTTP"
  }
}
