# 1. Configuration du Provider AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" # Région Paris
}

# 2. Création du Bucket S3
resource "aws_s3_bucket" "mon_bucket_terraform" {
  # /!\ Le nom doit être unique au MONDE. 
  # Ajoute ton nom ou des chiffres pour éviter les erreurs.
  bucket = "mon-projet-devops-2026-votre-nom" 

  tags = {
    Name        = "Terraform State Storage"
    Environment = "Dev"
  }
}

# 3. Activation du versioning (Sécurité pour ton futur State)
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.mon_bucket_terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Blocage de l'accès public (Bonne pratique de sécurité)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.mon_bucket_terraform.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
