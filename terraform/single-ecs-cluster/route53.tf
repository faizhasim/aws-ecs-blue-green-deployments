locals {
  name = "test.faizhasim.tech"
}

resource "aws_route53_record" "www" {
  zone_id = "${var.route53_zone_id}"
  name    = "${local.name}"
  type    = "A"

  alias {
    evaluate_target_health = true
    name = "${module.simple-service.lb_dns_name}"
    zone_id = "${module.simple-service.lb_zone_id}"
  }

}
