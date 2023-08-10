provider "kubernetes" {
  config_path    = var.kube_config
  config_context = var.kube_context
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

resource "helm_release" "release" {
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
