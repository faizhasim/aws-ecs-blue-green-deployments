module "simple-service-green" {
  source = "../../terraform-modules/simple-service"
  service-name = "simple-service-green"
  vpc_id = "${data.terraform_remote_state.shared.vpc_id}"
  vpc_cidr = "${data.terraform_remote_state.shared.vpc_cidr_block}"
  lb_subnetids = "${data.terraform_remote_state.shared.public_subnets}"
  awsvpc_task_execution_role_arn = "${data.terraform_remote_state.shared.task_execution_role_arn}"
  awsvpc_service_subnetids = "${data.terraform_remote_state.shared.private_subnets}"
  docker_image_tag = "${var.docker_image_tag}"
}

//module "simple-service-blue" {
//  source = "modules\/simple-service"
//  service-name = "simple-service-blue"
//  vpc_id = "${module.vpc.vpc_id}"
//  vpc_cidr = "${module.vpc.vpc_cidr_block}"
//  lb_subnetids = "${module.vpc.public_subnets}"
//  awsvpc_task_execution_role_arn = "${aws_iam_role.ecs-iam-role.arn}"
//  awsvpc_service_subnetids = "${module.vpc.private_subnets}"
//}
