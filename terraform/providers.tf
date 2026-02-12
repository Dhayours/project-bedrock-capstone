provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = "barakat-2025-capstone"
    }
  }
}
