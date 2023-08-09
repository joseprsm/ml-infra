terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kube_config
  config_context = "minikube"
}

module "argocd" {
  source = "./modules/install"
  name = "argocd"
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}
