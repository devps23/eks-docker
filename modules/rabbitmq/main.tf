resource "aws_security_group" "security_group" {
  name = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 5672
    to_port   = 5672
    protocol = "TCP"
    cidr_blocks = var.server_app_port_cidr
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}
resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [aws_security_group.security_group.id]
  instance_type          = var.instance_type
  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }
  root_block_device{
    encrypted  = true
    kms_key_id = var.kms_key_id
  }
  tags = {
    Name = var.component
    env = var.env
  }
}
# to run rabbitmq.sh through provisioner
resource "null_resource" "rabbitmq" {
  connection {
    type     =   "ssh"
    port     =    22
    host     =    aws_instance.instance.private_ip
    user     =    "ec2-user"
    password =    "DevOps321"
  }
  provisioner "file" {
    source        =  "${path.module}/rabbitmq.sh"
    destination   = "/tmp/rabbitmq.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/rabbitmq.sh"
    ]
  }
}
resource "aws_route53_record" "server" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.instance.private_ip]
  ttl     = 30
}





