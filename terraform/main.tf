provider "kubernetes" {
  config_path    = var.kube_config
  config_context = "minikube"
}

module "argocd" {
  source = "./modules/install"
  name   = "argocd"
  url    = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

module "argo_workflows" {
  source = "./modules/install"
  name   = "argo"
  url    = "https://github.com/argoproj/argo-workflows/releases/download/v3.4.9/install.yaml"
}
