resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id            = "${var.component}-${var.env}"
  engine                = var.component
  engine_version        = var.engine_version
  node_type             = var.node_type
  num_cache_nodes       = 1
  port                  = 6379
  parameter_group_name  = aws_elasticache_parameter_group.pg.name
  subnet_group_name     = aws_elasticache_subnet_group.sg.name
  security_group_ids    = [aws_security_group.security_group.id]
}
resource "aws_elasticache_subnet_group" "sg" {
  name       = "${var.component}-${var.env}-sg"
  subnet_ids = var.subnets
  tags = {
     Name  = "${var.component}-${var.env}-sg"
  }
}
resource "aws_elasticache_parameter_group" "pg" {
  name          = "${var.component}-${var.env}-pg"
  family        = var.family
  tags = {
    Name = "${var.component}-${var.env}-pg"
  }
}
resource "aws_security_group" "security_group" {
  name = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol = "TCP"
    cidr_blocks = var.server_app_port_cidr
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}