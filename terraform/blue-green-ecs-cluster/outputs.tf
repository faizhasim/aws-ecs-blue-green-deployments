
output "blue_lb_dns_name" {
  value = "${module.simple-service-blue.lb_dns_name}"
}

output "blue_lb_zone_id" {
  value = "${module.simple-service-blue.lb_zone_id}"
}

output "green_lb_dns_name" {
  value = "${module.simple-service-green.lb_dns_name}"
}

output "green_lb_zone_id" {
  value = "${module.simple-service-green.lb_zone_id}"
}
