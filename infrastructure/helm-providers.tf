# =============================================================================
# Helm Provider Configuration
# =============================================================================
# Configures the Helm provider to deploy charts into the EKS cluster.
# Authentication is handled via the AWS CLI exec-based token retrieval,
# which is the same mechanism used by the Kubernetes provider.
# =============================================================================

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
      command     = "aws"
    }
  }
}