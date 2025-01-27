// create an eks cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.env}-${var.component}"
  role_arn = aws_iam_role.cluster-role.arn
  vpc_config {
    subnet_ids = var.subnet_id
  }
  #   this is for kms to encrypt disk in an ec2 instance
  encryption_config {
    provider {
      key_arn = var.kms_key_id
    }
    resources = ["secrets"]
  }
}
# //create a security group
resource "aws_security_group" "security" {
  name        = "security-${var.component}-${var.env}"
  description = "security-${var.component}-${var.env}"
  vpc_id      = var.vpc_id
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-${var.component}-eks"
  }
}

# resource "aws_eks_node_group" "eks-node-group" {
#   cluster_name    = aws_eks_cluster.eks-cluster.name
#   node_group_name = "${var.env}-${var.component}-nodegrp"
#   node_role_arn   = aws_iam_role.eks-cluster-role.arn
#   subnet_ids      = var.subnet_id
#   instance_types  = ["t3.medium"]
#   capacity_type   =  "SPOT"
#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }
#   launch_template {
#     version = "$Latest"
#     name = aws_launch_template.launch_template.name
#   }
#   update_config {
#     max_unavailable = 1
#   }
#   tags = {
#     Name = "${var.env}-${var.component}-nodegrp"
#   }
# }
# create a node group and node group policy
# attach launch template in node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.env}-eks-ng"
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = var.subnet_id
  capacity_type   = "SPOT"
  instance_types  = ["t3.medium"]

    launch_template {
      name    = "${var.env}-${var.component}-template"
      version = "$Latest"
    }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  tags = {
    Name = "${var.env}-eks-ng"
  }
}

# create a launch template for ami
resource "aws_launch_template" "launch_template" {
  name = "${var.env}-${var.component}-template"
#   disk
  block_device_mappings {
    device_name = "/dev/sdf"
#     ebs storage
    ebs {
      volume_size           = 100
      kms_key_id            = var.kms_key_id
      encrypted             = true
      delete_on_termination = true
    }
  }
#   tag specification for instance name
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-${var.component}-template"
    }
  }
}

# kms and ec2 both are services whereas autoscaling group is not a service, so to communicate kms to asg need to add "key users" under kms