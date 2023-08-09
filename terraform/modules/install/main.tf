resource "kubernetes_namespace" "install_namespace" {
    metadata {
      name = var.name
    }
}

resource "kubernetes_manifest" "install_manifest" {
    count = length(local.hcl_manifests)

    manifest = merge(
        local.hcl_manifests[count.index],
        {
            "metadata": merge(
                local.hcl_manifests[count.index].metadata,
                {
                    "namespace": lookup(local.hcl_manifests[count.index], "kind", "") == "PriorityClass" || lookup(local.hcl_manifests[count.index], "kind", "") == "CustomResourceDefinition" || lookup(local.hcl_manifests[count.index], "kind", "") == "ClusterRoleBinding" || lookup(local.hcl_manifests[count.index], "kind", "") == "ClusterRole" ? null : kubernetes_namespace.install_namespace.metadata[0].name
                }
            )
        }
    )
}

data "http" "install_file" {
    url = var.url
}

locals {
  raw_manifests = split("---", data.http.install_file.response_body)
  hcl_manifests = [ for manifest in local.raw_manifests : yamldecode(manifest) ]
}
