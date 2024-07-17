module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "6.7.0"
  identifier = "java-dbs"
  depends_on = [module.vpc]
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  db_name  = var.db_name
  username = var.username
  port     = var.port
  iam_database_authentication_enabled = true
  vpc_security_group_ids = [module.security-group.security_group_id]
  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name
  create_monitoring_role = var.create_monitoring_role
  create_cloudwatch_log_group     = true
  # DB subnet group
  create_db_subnet_group = var.create_db_subnet_group
  subnet_ids             = module.vpc.database_subnets[*]
  # DB parameter group
  family = var.family
  # DB option group
  major_engine_version = var.major_engine_version
  # Database Deletion Protection
  deletion_protection = var.deletion_protection
  manage_master_user_password= var.manage_master_user_password
}
data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:426857564226:secret:java-secrets-1I1VMY"
}
