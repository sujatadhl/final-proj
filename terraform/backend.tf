terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "426857564226/sujata-final.tfstate"
    bucket         = "8586-terraform-state"
  }
}
  