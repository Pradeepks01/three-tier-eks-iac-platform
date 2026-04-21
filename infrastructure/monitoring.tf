# =============================================================================
# Monitoring Stack — Prometheus & Grafana (Optional)
# =============================================================================
# Deploys the kube-prometheus-stack Helm chart for cluster observability.
# This includes Prometheus for metrics collection, Grafana for dashboards,
# and Alertmanager for notifications.
#
# This is OPTIONAL and commented out by default to keep the initial
# deployment lightweight. Uncomment to enable monitoring.
#
# Prerequisites:
#   - EKS cluster must be fully provisioned
#   - Helm values file: ../kubernetes/helm-values/prometheus-stack.yaml
# =============================================================================

# resource "time_sleep" "wait_for_kubernetes" {
#   depends_on = [module.eks]
#   create_duration = "30s"
# }

# resource "kubernetes_namespace" "monitoring" {
#   depends_on = [time_sleep.wait_for_kubernetes]
#   metadata {
#     name = "monitoring"
#   }
# }

# resource "helm_release" "prometheus" {
#   depends_on       = [kubernetes_namespace.monitoring, time_sleep.wait_for_kubernetes]
#   name             = "prometheus"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = kubernetes_namespace.monitoring.id
#   create_namespace = true
#   version          = "51.3.0"
#   timeout          = 2000
#
#   values = [
#     file("../kubernetes/helm-values/prometheus-stack.yaml")
#   ]
#
#   set {
#     name  = "podSecurityPolicy.enabled"
#     value = true
#   }
#
#   set {
#     name  = "server.persistentVolume.enabled"
#     value = false
#   }
# }