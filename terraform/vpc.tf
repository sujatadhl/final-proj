#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"
  name                = "${var.name}-vpc"
  cidr                = var.cidr
  azs                 = var.azs
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets 
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway = true
  manage_default_security_group = false
}
