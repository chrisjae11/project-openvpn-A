resource "aws_instance" "ovpn" {
  ami                    = "${data.aws_ami.openvpn.id}"
  instance_type          = "t2.small"
  subnet_id              = "${aws_subnet.public-1a.id}"
  vpc_security_group_ids = ["${aws_security_group.efs-sg.id}"]
  key_name               = "${aws_key_pair.mykeypair.key_name}"
  user_data              = "${data.template_file.init.rendered}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ovpn-master"
  }

  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[vpn]
${aws_instance.ovpn.public_ip}

EOF
EOD
  }

  provisioner "local-exec" {
    command = <<EOD
aws ec2 wait instance-status-ok --instance-ids ${aws_instance.ovpn.id} && \
ansible-playbook -i aws_hosts ./ansible/ovpn-config.yml
EOD
  }


}
