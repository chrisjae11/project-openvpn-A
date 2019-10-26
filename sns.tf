resource "aws_sns_topic" "slack-notify" {
  name = "vpn-alert"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = "${aws_sns_topic.slack-notify.arn}"
  protocol = "lambda"

  endpoint = "${aws_lambda_function.slack.arn}"
}
