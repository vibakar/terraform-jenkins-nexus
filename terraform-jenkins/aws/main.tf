resource "aws_key_pair" "jenkins" {
  key_name   = "mac-ssh-key"
  public_key = file(var.KEY_PATH)
}

resource "aws_instance" "jenkins" {
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = var.INSTANCE_TYPE
  key_name               = aws_key_pair.jenkins.key_name
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  subnet_id              = aws_subnet.jenkins.id
  user_data_base64       = base64encode(data.cloudinit_config.jenkins.rendered)

  tags = {
    "Name" = "jenkins"
  }
}

data "cloudinit_config" "jenkins" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content = templatefile("scripts/jenkins_setup.sh", {
      jenkins_version = "2.346.1"
    })
  }
}