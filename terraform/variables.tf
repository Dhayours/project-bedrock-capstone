variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "student_id" {
  description = "Used to make assets bucket unique (e.g., yourname-123)"
  type        = string
}

variable "assets_bucket_prefix" {
  description = "Prefix for the S3 assets bucket name"
  type        = string
  default     = "bedrock-assets"
}

variable "vpc_name_tag" {
  description = "Value for the VPC Name tag"
  type        = string
  default     = "bedrock-vpc"
}

variable "dev_iam_user" {
  description = "IAM username for the dev view-only user"
  type        = string
  default     = "bedrock-dev-view"
}

variable "lambda_name" {
  description = "Lambda function name for asset processing"
  type        = string
  default     = "bedrock-asset-processor"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}
