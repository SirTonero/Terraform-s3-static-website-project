terraform {
   required_providers {
      aws = {
         source = "hashicorp/aws"
         version = "5.17.0"
      }
   }
}

provider "aws" {
   region = "us-east-1"
}

resource "terraform_data" "content_version" {
   input = var.content_version
}