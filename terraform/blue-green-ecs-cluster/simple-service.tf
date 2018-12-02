module "simple-service-green" {
  source = "../../terraform-modules/simple-service"
  service-name = "simple-service-green"
  vpc_id = "${data.terraform_remote_state.shared.vpc_id}"
  vpc_cidr = "${data.terraform_remote_state.shared.vpc_cidr_block}"
  lb_subnetids = "${data.terraform_remote_state.shared.public_subnets}"
  awsvpc_task_execution_role_arn = "${data.terraform_remote_state.shared.task_execution_role_arn}"
  awsvpc_service_subnetids = "${data.terraform_remote_state.shared.private_subnets}"
  docker_image_tag = "${var.green_docker_image_tag}"
}

module "simple-service-blue" {
  source = "../../terraform-modules/simple-service"
  service-name = "simple-service-blue"
  vpc_id = "${data.terraform_remote_state.shared.vpc_id}"
  vpc_cidr = "${data.terraform_remote_state.shared.vpc_cidr_block}"
  lb_subnetids = "${data.terraform_remote_state.shared.public_subnets}"
  awsvpc_task_execution_role_arn = "${data.terraform_remote_state.shared.task_execution_role_arn}"
  awsvpc_service_subnetids = "${data.terraform_remote_state.shared.private_subnets}"
  docker_image_tag = "${var.blue_docker_image_tag}"
}
