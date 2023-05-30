variable "argocd_namespace" {
    type = string
    default = "argocd"
}

variable "kube_config" {
    type = string
    default = "~/.kube/config"
}