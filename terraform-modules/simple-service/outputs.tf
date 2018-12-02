output "service_url" {
  description = "Service urls"
  value       = "${module.simple-website.service_url}"
}

output "lb_dns_name" {
  description = "Loadbalancer DNS Name"
  value       = "${module.simple-website.lb_dns_name}"
}

output "lb_zone_id" {
  description = "Loadbalancer Zone ID"
  value       = "${module.simple-website.lb_zone_id}"
}

output "task_definition_arn" {
  description = "Task definition ARN"
  value       = "${module.simple-website.task_definition_arn}"
}

output "lb_target_group_arn" {
  description = "Loadbalancer Target Group ARN"
  value       = "${module.simple-website.lb_target_group_arn}"
}

