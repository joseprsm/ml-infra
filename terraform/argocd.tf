resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "kubernetes_manifest" "argocd_install" {
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

resource "kustomization_resource" "argocd_apps" {
  for_each = {
    for kustomize in flatten([
      for build in data.kustomization_build.build : [
        for id in build.ids : {
          id = id
          manifest = build.manifests[id]
        }
      ]
    ]) : "${kustomize.id}" => kustomize
  }
  manifest = each.value.manifest 
  depends_on = [ kubernetes_manifest.argocd_install ]
}

data "http" "argocd_install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

data "kustomization_build" "build" {
  for_each = fileset("../argocd/apps", "**")
  path = "../argocd/apps/${dirname(each.value)}"
}

locals {
  raw_argocd_manifests = split("---", data.http.argocd_install.response_body)
  hcl_argocd_manifests = [ for argo_manifest in local.raw_argocd_manifests : yamldecode(argo_manifest) ]
}
