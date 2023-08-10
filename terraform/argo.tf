resource "helm_release" "argo" {
  for_each = {
    argo-cd = {
      name      = "argocd"
      namespace = "argocd"
    }
    argo-workflows = {
      name      = "argo-workflows"
      namespace = "argo"
    }
  }

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = each.key
  name             = each.value.name
  namespace        = each.value.namespace
  create_namespace = true
}
