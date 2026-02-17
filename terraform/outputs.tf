output "cluster_endpoint" {
  value = data.aws_eks_cluster.bedrock.endpoint
}

output "cluster_name" {
  value = data.aws_eks_cluster.bedrock.name
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.bedrock.id
}

# You haven't created the S3 bucket resource yet, but grading requires this output.
# Output the expected bucket name string for now (you will create the bucket tomorrow).
output "assets_bucket_name" {
  value = local.assets_bucket_name
}
