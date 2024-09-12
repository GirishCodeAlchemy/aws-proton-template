provider "aws" {
  region = local.region
  
  default_tags {
    tags = {
      "environment"        = "${local.environment}"
      "owner"              = "GirishCodeAlchemy@gmail.com"
      "provisioned-by"     = local.provisioned_by_tag
      "longterm"           = "forever"
      "commit-hash"        = var.commit_hash
    }
  }
}

terraform {
  required_providers {
    aws = {
      version = "~> 3.63.0"
    }
  }
  required_version = ">= 0.14"
}