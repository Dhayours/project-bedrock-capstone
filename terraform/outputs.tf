output "region" {
  value = var.aws_region
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "vpc_id" {
  value = aws_vpc.bedrock.id
}

output "cluster_name" {
  value = aws_eks_cluster.bedrock.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.bedrock.endpoint
}

# Grading: show dev IAM access key (sensitive)
output "bedrock_dev_view_access_key_id" {
  value     = aws_iam_access_key.dev_view_key.id
  sensitive = true
}

output "bedrock_dev_view_secret_access_key" {
  value     = aws_iam_access_key.dev_view_key.secret
  sensitive = true
}
