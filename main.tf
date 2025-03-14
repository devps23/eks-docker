module "vpc"{
  source                   = "./modules/vpc"
  vpc_cidr_block           = var.vpc_cidr_block
  env                      = var.env
  default_vpc_id           = var.default_vpc_id
  default_vpc_cidr_block   = var.default_vpc_cidr_block
  default_route_table_id   = var.default_route_table_id
  frontend_subnets         = var.frontend_subnets
  backend_subnets          = var.backend_subnets
  mysql_subnets            = var.mysql_subnets
  availability_zone        = var.availability_zone
  public_subnets           = var.public_subnets
}
# module "rds"{
#   source                  = "./modules/rds"
#   component               = "mysql"
#   env                     = var.env
#   vpc_id                  = module.vpc.vpc_id
#   rds_app_port            = 3306
#   server_app_port_cidr    = var.backend_subnets
#   subnet_id               = module.vpc.mysql_subnets
#   allocated_storage       = 20
#   db_name                 = "mydb"
#   engine                  = "mysql"
#   engine_version          = "8.0.36"
#   instance_class          = "db.t3.micro"
#   storage_type            = "gp3"
#   kms_key_id              = var.kms_key_id
# }
module "eks"{
  source                    =  "./modules/eks"
  env                       =  var.env
  subnet_id                 =  module.vpc.backend_subnets
  component                 = "eks-cluster"
  kms_key_id                = var.kms_key_id
  vpc_id                    = module.vpc.vpc_id
  bastion_nodes             = var.bastion_nodes
}