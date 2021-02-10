provider "aws" {
  region = "eu-central-1"
}

module "shdkej-network" {
  source = "./aws_network"
}

terraform {
  backend "s3" {
    bucket = "shdkej-personal-state.shdkej.com"
    key = "kubernetes-test"
    region = "eu-central-1"
  }
}
