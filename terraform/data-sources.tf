# Pull in the existing EKS cluster (created outside this root module)
data "aws_eks_cluster" "bedrock" {
  name = var.cluster_name
}

# Optional: useful later if you want to read auth data
data "aws_eks_cluster_auth" "bedrock" {
  name = var.cluster_name
}
