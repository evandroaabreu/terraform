# Configuração do provider AWS
provider "aws" {
  region = "us-east-1"  # Altere para sua região preferida
}

# Criação do bucket S3
resource "aws_s3_bucket" "meu_bucket" {
  bucket = "my-terraform-state-ev"  # O nome do bucket deve ser único globalmente
}

# Configuração de versionamento do bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.meu_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configuração de criptografia do bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.meu_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquear acesso público ao bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.meu_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 