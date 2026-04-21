# =============================================================================
# VPC — Virtual Private Cloud
# =============================================================================
# Creates a production-ready VPC with public and private subnets across
# two availability zones. The private subnets host EKS worker nodes,
# while the public subnets are used by the ALB Ingress Controller.
#
# A single NAT Gateway is used to keep costs low in development.
# For production, set single_nat_gateway = false for high availability.
# =============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.availability_zones
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]

  # Tags required by the AWS Load Balancer Controller for auto-discovery
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  # NAT Gateway — single for cost savings, one-per-AZ for production HA
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # DNS settings (required for EKS and service discovery)
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "dev"
    Project     = "three-tier-eks"
    ManagedBy   = "terraform"
  }
}