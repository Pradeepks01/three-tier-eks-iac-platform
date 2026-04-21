# =============================================================================
# Cluster Autoscaler — IAM Role (IRSA)
# =============================================================================
# Creates an IAM role for the Cluster Autoscaler using IRSA. This gives
# the autoscaler pod the minimum permissions needed to describe and
# modify Auto Scaling Groups without sharing node-level credentials.
# =============================================================================

module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.1"

  role_name                        = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}