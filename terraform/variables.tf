variable "region" {
  description = "AWS region for Project Bedrock"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name (required by grader)"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "student_id" {
  description = "Student ID used for unique naming (e.g., S3 bucket suffix)"
  type        = string
  default     = "0960"
}

variable "assets_bucket_prefix" {
  description = "S3 assets bucket prefix required by grader"
  type        = string
  default     = "bedrock-assets"
}

variable "lambda_name" {
  description = "Lambda function name required by grader"
  type        = string
  default     = "bedrock-asset-processor"
}

variable "dev_iam_user" {
  description = "Developer IAM user required by grader"
  type        = string
  default     = "bedrock-dev-view"
}
