resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_manifest" "argocd-manifests" {
  count = length(local.hcl_argocd_manifests)

  manifest = merge(
    local.hcl_argocd_manifests[count.index],
    {
      "metadata" : merge(
        local.hcl_argocd_manifests[count.index].metadata,
        {
          "namespace": lookup(local.hcl_argocd_manifests[count.index], "kind", "") == "CustomResourceDefinition" || lookup(local.hcl_argocd_manifests[count.index], "kind", "") == "ClusterRoleBinding" || lookup(local.hcl_argocd_manifests[count.index], "kind", "") == "ClusterRole" ? null : kubernetes_namespace.argocd_namespace.metadata[0].name
        }
      )
    }
  )
}

data "http" "argocd_install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

locals {
  raw_argocd_manifests = split("---", data.http.argocd_install.response_body)
  hcl_argocd_manifests = [for argo_manifest in local.raw_argocd_manifests : yamldecode(argo_manifest)]
}
