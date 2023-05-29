terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomize"
      version = "0.2.0-beta.3"
    }
  }
  required_version = ">= 0.12"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "kustomization" {}