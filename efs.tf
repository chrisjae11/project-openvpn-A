resource "aws_efs_file_system" "ovpn-efs" {
  creation_token = "ovpn-efs"
  tags = {
    Name = "ovpn-efs"
  }
}

resource "aws_efs_mount_target" "tg01" {
  file_system_id  = "${aws_efs_file_system.ovpn-efs.id}"
  subnet_id       = "${aws_subnet.public-1a.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

resource "aws_efs_mount_target" "tg02" {
  file_system_id  = "${aws_efs_file_system.ovpn-efs.id}"
  subnet_id       = "${aws_subnet.public-1b.id}"
  security_groups = ["${aws_security_group.efs-sg.id}"]
}
