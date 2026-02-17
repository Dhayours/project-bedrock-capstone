terraform {
  backend "s3" {
    bucket         = "bedrock-tfstate-842833233945"
    key            = "project-bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-tf-lock"
    encrypt        = true
  }
}
