# resource "aws_kms_key" "slack-kms-key" {
#   description = "kms key for slack"
#
# }
#


resource "aws_lambda_function" "slack" {
  filename      = "${data.archive_file.slack.output_path}"
  function_name = "slack"
  role          = "${aws_iam_role.slack-role.arn}"
  handler       = "slack.lambda_handler"
  runtime       = "python3.7"
  source_code_hash = filebase64sha256(data.archive_file.slack.output_path)


  environment {
    variables = {

      kmsEncryptedHookUrl = aws_kms_ciphertext.slack-url.ciphertext_blob
      slackChannel = "${var.channel}"

    }
  }

}

data "archive_file" "slack" {
  type        = "zip"
  source_file = "slack.py"
  output_path = "slack.zip"
}

resource "aws_lambda_permission" "slack-permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.slack.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.slack-notify.arn}"
}
