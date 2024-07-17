variable "region" {
  description = "Region be used for all the resources"
  type        = string
  default     = "us-east-1"
}
variable "s3_policy" {
  type = string
}

variable "project" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "teraform_modules"
}

variable "terraform" {
  description = "Name to be used on all the resources as identifier"
  type        = bool
  default     = true
}

variable "owner" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "silo" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
variable "name" {
  description = "name of the application"
  type = string
}

variable "cidr"{
  description = "Cidr block"
  type        = string
  default     = ""
}

variable "azs"{
  description = "availability zone "
  type        = list(string)
}

variable "private_subnets"{
  description = "private subnets "
  type        =  list(string)
}
variable "public_subnets"{
  description = "public Subnets "
  type        =  list(string)
}
variable "database_subnets"{
  description = "database subnet"
  type = list(string)
}



variable "image_id"{
  description = "image id for Ec2"
  type = string
}

variable "launch_template_name"{
  description = "launch template name for auto AutoScaling"
  type = string
}

variable "instance_type" {
  description = "instance type for Ec2"
  type = string  
}

variable "monitoring" {
  description= "monitoring for autoscaling"
  type = string
}

variable "create_iam_instance_profile" {
  description = "Create IAM instance profile"
  type= string
}

variable "ssm_policy" {
  description = "Arn for ssm policy"
  type= string
}
variable "codedeploy" {
  description = "Arn for code deploy"
  type= string
}

variable "enable_nat_gateway" {
  description = "Enabling nat gateway"
  type = bool
}

variable "engine" {
  description = "db engine type"
  type = string
}

variable "engine_version" {
  description = "db engine version"
  type = string
}

variable "instance_class" {
  description = "db engine intance class"
  type = string
}

variable "allocated_storage" {
  description = "allocated storage for db"
  type = string
}

variable "db_name"{
  description = "db name"
  type =string
} 

variable "username"{
  description = "db username"
  type =string
}    

variable "port"{
  description = "db port"
  type =string
}     

variable "monitoring_interval"{
  description = "monitoring interval"
  type =string
}
variable "monitoring_role_name"{
  description = "monitoring role name"
  type =string
}
variable "create_monitoring_role"{
  description = "create monitoring role"
  type =bool
}

variable "create_db_subnet_group"{
  description = "create db_subnet_group"
  type =bool
}
variable "deletion_protection"{
  description = "Enable delettion preotectio"
  type =bool
}


variable "major_engine_version"{
  description = "major engine version"
  type = string
}

variable "family"{
  description = "db parameter family"
  type =string
}

variable "manage_master_user_password"{
  type=bool
}

variable "bucket_name" {
  description = "Bucket to store artifacts"
  type= string
  }

variable "repo_owner" {
  description = "github username"
  type = string
}  

variable "repo_name" {
  description = "github repository name"
  type = string
}  
variable "repo_branch" {
  description = "github repository branch name"
  type = string
}  

variable "email" {
  description = "Email subscription for sns"
  type = string
  }

variable "cloudwatch_logs" {
  description = "clouwatch policy"
  type = string  
}

