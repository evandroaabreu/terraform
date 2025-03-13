terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }
  backend "s3" {
    bucket = "my-terraform-state-ev"
    key    = "state_ecr/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1" # Altere para a região desejada
}

resource "aws_ecr_repository" "my_repo" {
  name                 = "meu-repositorio"
  image_tag_mutability = "MUTABLE"

}

output "repository_url" {
  value = aws_ecr_repository.my_repo.repository_url
}
