output "iam_codedeploy" {
    value= module.iam_codedeploy.iam_role_arn
}

output "iam_codebuild" {
    value= module.iam_codebuild.iam_role_arn
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnets
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "topic_arn"{
  value = module.sns_topic.topic_arn
 }
 output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db.db_instance_master_user_secret_arn
}
output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db.db_instance_cloudwatch_log_groups
}