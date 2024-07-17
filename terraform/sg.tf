module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  depends_on = [ module.vpc ]
  name        = "java-sg"
  vpc_id      = module.vpc.vpc_id
  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "mysql access from within VPC"

    }
  ]
  egress_rules       = ["all-all"]
  # egress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
}