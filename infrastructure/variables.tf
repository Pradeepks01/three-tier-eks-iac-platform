# =============================================================================
# Input Variables
# =============================================================================
# Centralizes all configurable parameters for the infrastructure stack.
# Override defaults via terraform.tfvars or -var flags.
# =============================================================================

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "three-tier-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster (e.g. 1.28)"
  type        = string
  default     = "1.28"
}

variable "region" {
  description = "AWS region where all resources will be provisioned"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of availability zones for high-availability networking"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "addons" {
  description = "List of EKS managed add-ons to install on the cluster"
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.28.2-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.14.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.10.1-eksbuild.5"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.25.0-eksbuild.1"
    }
  ]
}