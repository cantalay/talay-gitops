variable "kubeconfig_path" {
  type    = string
  default = "../talay-cluster/stacks/bootstrap/kubeconfig.yaml"
}

variable "argocd_domain" {
  type = string
}

variable "keycloak_issuer" {
  description = "Örnek: https://auth.example.com/realms/talay"
  type        = string
}

variable "environments_repo_url" {
  type = string
}

variable "charts_repo_url" {
  type = string
}

variable "git_revision" {
  type    = string
  default = "main"
}
