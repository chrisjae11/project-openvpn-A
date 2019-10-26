resource "aws_iam_role" "slack-role" {
  name = "lambda-role"

  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}


data "aws_iam_policy_document" "slack-policy" {
  # source_json = data.aws_iam_policy_document.lambda_basic.json
  statement {
    sid = "AllowKMSDecrypt"
    effect = "Allow"
    actions = ["kms:Decrypt"]

    resources = [aws_kms_key.slack-kms.arn]
  }

  statement {
    sid    = "CloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}


resource "aws_iam_role_policy" "slack-lambda-policy" {
  name   = "SlackNotifications"
  role   = "${aws_iam_role.slack-role.id}"
  policy = "${data.aws_iam_policy_document.slack-policy.json}"

}
