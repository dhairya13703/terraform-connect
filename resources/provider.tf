terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.0"
      configuration_aliases = [aws]
    }
  }
}

provider "aws" {
    profile = "digiclarity"
  region = var.region
}