output "elastic-ips" {
  value = ["${aws_eip.ovpn-eip.*.public_ip}"]
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.slack-notify.arn}"
}
