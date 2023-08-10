resource "helm_release" "argocd" {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
}

resource "kubernetes_manifest" "ml_apps" {
    manifest = yamldecode(file("../argocd/application.yaml"))
    depends_on = [ helm_release.argo ]
}
