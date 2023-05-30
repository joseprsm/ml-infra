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

provider "kustomization" {
  kubeconfig_path = var.kube_config
}
