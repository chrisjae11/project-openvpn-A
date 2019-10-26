
resource "aws_launch_configuration" "ovpn-lc" {
  name_prefix     = "ovpn-lauchconfig"
  image_id        = "${data.aws_ami.openvpn.id}"
  # image_id        = "ami-06b94666"
  instance_type   = "${var.lc_instance_type}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
  key_name        = "${aws_key_pair.mykeypair.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.eip-profile.name}"
  user_data       = "${data.template_file.assign-ip.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "ovpn-asg" {
  name                      = "ovpn-asg"
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "${var.asg_hct}"
  desired_capacity          = "${var.asg_cap}"
  force_delete              = true

  vpc_zone_identifier  = ["${aws_subnet.public-1a.id}", "${aws_subnet.public-1b.id}"]
  launch_configuration = "${aws_launch_configuration.ovpn-lc.name}"

  depends_on = [aws_instance.ovpn]

  tag {
    key                 = "Name"
    value               = "ovpn-node"
    propagate_at_launch = true

  }
}
