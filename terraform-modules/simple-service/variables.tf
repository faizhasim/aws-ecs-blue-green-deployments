variable "service-name" {
  default     = "rainbow"
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = "string"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC."
  type        = "string"
}

variable "lb_subnetids" {
  description = "List of subnets to which the load balancer needs to be attached. Mandatory when enable_lb = true."
  type        = "list"
  default     = []
}

variable "awsvpc_task_execution_role_arn" {
  description = "The role arn used for task execution. Required for network mode awsvpc."
  type        = "string"
  default     = ""
}

variable "awsvpc_service_subnetids" {
  description = "List of subnet ids to which a service is deployed in fargate mode."
  type        = "list"
  default     = []
}

variable "docker_image_tag" {
  default     = "latest"
}
