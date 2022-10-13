resource "aws_key_pair" "nexus" {
  key_name   = "ssh-key-mac"
  public_key = file(var.KEY_PATH)
}

resource "aws_instance" "nexus" {
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = var.INSTANCE_TYPE
  key_name               = aws_key_pair.nexus.key_name
  vpc_security_group_ids = [aws_security_group.nexus.id]
  subnet_id              = aws_subnet.nexus.id
  user_data_base64       = base64encode(data.cloudinit_config.nexus.rendered)

  tags = {
    "Name" = "nexus"
  }
}

data "cloudinit_config" "nexus" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("scripts/nexus_setup.sh", {})
  }
}