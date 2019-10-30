variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "private_key" {
  default = "mykey"
}

variable "public_key" {
  default = "mykey.pub"
}

variable "delegation_set" {}


variable "eip_count" {
  default = 2
}



variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}
# variable "count" {
#   default = 1
# }
#
variable "domain_name" {
  default = "logicflux.tech"
}
# variable "dev_instance_type" {
#   default = "t2.micro"
# }
# variable "elb_healthy_threshold" {
#   default = "2"
# }
# variable "elb_unhealthy_threshold" {
#   default = "2"
# }
# variable "elb_timeout" {
#   default = "3"
# }
# variable "elb_interval" {
#   default = "30"
# }
variable "asg_max" {
  default = "2"
}
variable "asg_min" {
  default = "1"
}
variable "asg_cap" {
  default = "2"
}
variable "asg_grace" {
  default = "300"
}
variable "asg_hct" {
  default = "ELB"
}

variable "lc_instance_type" {
  default = "t2.small"
}


variable "channel" {
  default = "vpn-alarm"
}
variable  "username" {
  default = "aws"
}
variable "slack_url" {}

variable "account_id" {}
