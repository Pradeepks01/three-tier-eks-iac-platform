# =============================================================================
# Terraform & Provider Configuration
# =============================================================================
# Defines the required Terraform version, provider dependencies, and
# the AWS provider configuration for this infrastructure stack.
# =============================================================================

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

# ── AWS Provider ──
provider "aws" {
  region = var.region
}