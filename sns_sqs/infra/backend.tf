terraform {
  backend "s3" {
    bucket         = "meu-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
