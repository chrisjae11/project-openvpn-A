resource "aws_route53_zone" "primary" {
  name = "${var.domain_name}"
  delegation_set_id = "${var.delegation_set}"
  force_destroy     = true
}

# resource "aws_route53_record" "ovpn-weight1" {
#   zone_id = "${aws_route53_zone.primary.zone_id}"
#   name = "vpn.logicflux.tech"
#   type = "CNAME"
#   ttl = "5"
#   set_identifier = "weight-1"
#   records = []
#
#   weighted_routing_policy {
#     weight = 10
#   }
# }
#
# resource "aws_route53_record" "ovpn-weight2" {
#   zone_id = "${aws_route53_zone.primary.zone_id}"
#   name = "vpn.logicflux.tech"
#   type = "CNAME"
#   ttl = "5"
#   set_identifier = "weight-2"
#   records = []
#
#   weighted_routing_policy {
#     weight = 10
#   }
# }
#
# resource "aws_route53_health_check" "ovpn-1" {
#   ip_address = "${aws_eip.ovpn-eip[0]}"
#   fqdn              = "vpn.logicflux.tech"
#   port              = 443
#   type              = "HTTPS"
#   resource_path     = "/"
#   failure_threshold = "5"
#   request_interval  = "30"
#
#   tags = {
#     Name = "ovpn-health-check"
#   }
# }
#
# resource "aws_route53_health_check" "ovpn-2" {
# ip_address = "${aws_eip.ovpn-eip[1].id}"
#   fqdn              = "vpn.logicflux.tech"
#   port              = 443
#   type              = "HTTPS"
#   resource_path     = "/"
#   failure_threshold = "5"
#   request_interval  = "30"
#
#   tags = {
#     Name = "ovpn-health-check"
#   }
# }
