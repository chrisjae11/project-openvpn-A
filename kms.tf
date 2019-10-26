resource "aws_kms_key" "slack-kms" {
  description = "kms for slack"
}

resource "aws_kms_alias" "slack-kms-alias" {
  name = "alias/kms-key"
  target_key_id = aws_kms_key.slack-kms.id
}

resource "aws_kms_ciphertext" "slack-url" {
  plaintext = "${var.slack_url}"
  key_id    = aws_kms_key.slack-kms.arn

}
