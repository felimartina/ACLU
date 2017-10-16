terraform {
  backend "s3" {
    bucket     = "felimartina.terraform"
    key        = "aclu/envs/stage/terraform.tfstate"
    region     = "us-east-1"
    profile    = "pipe"
  }
}

provider "aws" {
  access_key = "${var.ACCESS_KEY}"
  secret_key = "${var.SECRET_KEY}"
  region     = "${var.REGION}"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket     = "felimartina.terraform"
    key        = "aclu/envs/stage/terraform.tfstate"
    region     = "us-east-1"
    profile    = "pipe"
  }
}