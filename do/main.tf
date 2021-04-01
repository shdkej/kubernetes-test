terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 1.22"
    }
  }
}

terraform {
  backend "s3" {
    endpoint = "sgp1.digitaloceanspaces.com"
    region = "ap-southeast-1"
    key = "terraform.tfstate"
    bucket = "shdkej-state"

    skip_credentials_validation = true
    skip_metadata_api_check = true
  }
}

provider "digitalocean" {
  token = var.do_token
}
