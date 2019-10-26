resource "aws_iam_role" "eip-role" {
  name = "eip-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "eip-role"
  }
}

resource "aws_iam_policy" "eip-policy" {
  name        = "eip-policy"
  description = "autoscale eip policy"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
      "Effect": "Allow",
      "Action": [
          "ec2:DescribeAddresses",
          "ec2:AllocateAddress",
          "ec2:DescribeInstances",
          "ec2:AssociateAddress"
      ],
      "Resource": "*"
  }
]
}
EOF
}



resource "aws_iam_instance_profile" "eip-profile" {
  name = "eip-profile"
  role = "${aws_iam_role.eip-role.name}"
}

resource "aws_iam_policy" "route53-dns-alarm-policy" {
  name   = "rotue53-dns-policy"
  policy = "${data.template_file.policy.rendered}"
}


resource "aws_iam_policy_attachment" "eip-attach" {
  name       = "eip-attachment"
  roles      = ["${aws_iam_role.eip-role.name}"]
  policy_arn = "${aws_iam_policy.eip-policy.arn}"
}

resource "aws_iam_policy_attachment" "reoute53-dns-alarm-attach" {
  name = "route53-dns"
  roles = ["${aws_iam_role.eip-role.name}"]
  policy_arn = "${aws_iam_policy.route53-dns-alarm-policy.arn}"
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid    = "__default_statement_ID"
    effect = "Allow"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["${aws_sns_topic.slack-notify.arn}"]
  }

  statement {
    sid     = "AWSEvents_SendToSNS"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.slack-notify.arn}"]
  }
}
resource "aws_iam_policy_attachment" "node-sns-access" {
  name = "node-sns"
  roles = ["${aws_iam_role.eip-role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}

# resource "aws_sns_topic_policy" "sns-policy" {
#   arn = "${aws_sns_topic.slack-notify.arn}"
#   policy = "${data.aws_iam_policy_document.sns.json}"
#
# }
