# =============================================================================
# EKS Cluster — Amazon Elastic Kubernetes Service
# =============================================================================
# Provisions a managed Kubernetes cluster with two node groups:
#   1. general  — On-Demand instances for stable, always-on workloads
#   2. spot     — Spot instances for cost-efficient, fault-tolerant workloads
#
# IRSA (IAM Roles for Service Accounts) is enabled so pods can assume
# fine-grained IAM roles without sharing node-level credentials.
# =============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Endpoint access — private for node communication, public for kubectl
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Enable IRSA for pod-level IAM permissions
  enable_irsa = true

  # ── Default settings for all managed node groups ──
  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  # ── Managed Node Groups ──
  eks_managed_node_groups = {

    # On-Demand node group — for stable, critical workloads
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    # Spot node group — for cost-optimized, interruptible workloads
    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  # ── RBAC — Map IAM roles to Kubernetes groups ──
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups   = ["system:masters"]
    },
  ]

  # ── Security group rules ──
  # Allow the control plane to reach the ALB webhook on worker nodes
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow control plane to reach ALB controller webhook"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "three-tier-eks"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# EKS Cluster Data Sources & Kubernetes Provider
# =============================================================================
# These data sources fetch the cluster endpoint and auth token so the
# Kubernetes and Helm providers can communicate with the API server.
# Reference: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
# =============================================================================

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}