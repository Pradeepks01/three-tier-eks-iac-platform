# =============================================================================
# EKS Managed Add-ons
# =============================================================================
# Installs essential EKS add-ons (kube-proxy, vpc-cni, coredns, ebs-csi).
# These are AWS-managed and automatically patched.
#
# Uncomment the resource block below to enable managed add-on installation.
# The add-on versions are defined in variables.tf and should match your
# cluster_version to avoid compatibility issues.
# =============================================================================

# resource "aws_eks_addon" "addons" {
#   for_each          = { for addon in var.addons : addon.name => addon }
#   cluster_name      = module.eks.cluster_id
#   addon_name        = each.value.name
#   addon_version     = each.value.version
#   resolve_conflicts = "OVERWRITE"
# }