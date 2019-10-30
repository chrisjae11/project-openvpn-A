data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "template_file" "policy" {
  template = "${file("scripts/policy.json")}"

  # vars = {
  #   zone_id = "${aws_route53_zone.primary.zone_id}"
  # }
}


data "aws_ami" "openvpn" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "tag:Name"
    values = ["ovpn-server"]
  }

}

data "template_file" "init" {
  template = "${file("scripts/init.sh")}"

  vars = {
    efs_dns = "${aws_efs_mount_target.tg01.ip_address}"
  }
}

locals {
  sns_topic = "${aws_sns_topic.slack-notify.arn}"

  depends_on = [aws_sns_topic.slack-notify.arn]

}

data "template_file" "assign-ip" {
  template = "${file("scripts/assign-ip.sh")}"

  vars = {

    efs_dns = "${aws_efs_mount_target.tg01.ip_address}"
    instance_region = "${var.aws_region}",
    zone_id = "${aws_route53_zone.primary.zone_id}"
    sns_topic = "${local.sns_topic}"
  }

}
