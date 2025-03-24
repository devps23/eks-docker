resource "aws_docdb_cluster" "docdb" {
  cluster_identifier               = "my-docdb-cluster"
  engine                           = "${var.component}"
  engine_version                   = var.engine_version
  master_username                  = "docdb"
  master_password                  = "roboshop123"
  backup_retention_period          = 2
  preferred_backup_window          = "07:00-09:00"
  skip_final_snapshot              = true
  db_cluster_parameter_group_name  = aws_docdb_cluster_parameter_group.pg.id
  vpc_security_group_ids           = [aws_security_group.security_group.id]
  kms_key_id                       = var.kms_key_id
  storage_encrypted                = true
  db_subnet_group_name             = aws_docdb_subnet_group.subnet_group.id
}
resource "aws_docdb_cluster_parameter_group" "pg" {
  family = var.family
  name   = "${var.component}-${var.env}-pg"
  tags = {
    Name = "${var.component}-${var.env}-pg"
  }
}
resource "aws_docdb_subnet_group" "subnet_group" {
  name       = "${var.component}-${var.env}-sg"
  subnet_ids = var.subnets
  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class

  tags = {
    Name = "${var.component}-${var.env}-cluster-i"
  }
}
resource "aws_security_group" "security_group" {
  name   = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 27017
    to_port   = 27017
    protocol = "TCP"
    cidr_blocks = var.server_app_port_cidr
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name= "${var.component}-${var.env}-sg"
  }
}
