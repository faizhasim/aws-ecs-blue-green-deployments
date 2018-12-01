module "simple-service-green" {
  source = "./modules/simple-service"
  service-name = "simple-service-green"
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr_block}"
  lb_subnetids = "${module.vpc.public_subnets}"
  awsvpc_task_execution_role_arn = "${aws_iam_role.ecs-iam-role.arn}"
  awsvpc_service_subnetids = "${module.vpc.private_subnets}"
}

module "simple-service-blue" {
  source = "./modules/simple-service"
  service-name = "simple-service-blue"
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr_block}"
  lb_subnetids = "${module.vpc.public_subnets}"
  awsvpc_task_execution_role_arn = "${aws_iam_role.ecs-iam-role.arn}"
  awsvpc_service_subnetids = "${module.vpc.private_subnets}"
}
