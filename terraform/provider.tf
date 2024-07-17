provider "aws" {  
    region  = "us-east-1"
    default_tags  {
        tags = {
        silo = var.silo
        project = var.project
        owner = var.owner
        terraform = var.terraform
        }
    }
}