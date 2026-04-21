# =============================================================================
# Outputs — Useful values after terraform apply
# =============================================================================
# These outputs surface key resource identifiers and endpoints that you'll
# need for kubectl configuration, CI/CD pipelines, and DNS setup.
# =============================================================================

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster"
  value       = module.eks.cluster_version
}

output "vpc_id" {
  description = "ID of the VPC hosting the cluster"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (worker nodes)"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (load balancers)"
  value       = module.vpc.public_subnets
}

output "configure_kubectl" {
  description = "Command to configure kubectl for this cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_id}"
}
