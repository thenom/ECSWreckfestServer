provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Service = "WreckfestServer"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}
