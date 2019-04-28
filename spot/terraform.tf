provider "aws" {
  access_key = "AKIAZROWC2VLCACAPVJ2"
  secret_key = "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"
  region     = "eu-west-1"
}

resource "aws_spot_instance_request" "SpotInstance" {
  ami           = "ami-059703949673c59ef"
  spot_price    = "0.13"
  instance_type = "m5.large"

  tags = {
           Name = "SpotInstance"
        }
}
