terraform {
  backend "s3" {
    bucket  = "bedrock-tfstate-chukwuka-1021"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
