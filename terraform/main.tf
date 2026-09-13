terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network_module" {
  source = "./modules/network"
}

module "compute_module" {
  source             = "./modules/compute"
  vpc_id             = module.network_module.vpc_id
  public_subnet_ids  = module.network_module.public_subnet_ids
  private_subnet_ids = module.network_module.private_subnet_ids
  certificate_arn    = var.certificate_arn
}
