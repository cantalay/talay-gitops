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
  default     = null
  nullable    = true

  validation {
    condition     = !var.oidc_enabled || var.keycloak_issuer != null
    error_message = "oidc_enabled true olduğunda keycloak_issuer zorunludur."
  }
}

variable "oidc_enabled" {
  description = "Argo CD doğrudan OIDC loginini açar; local admin bundan bağımsızdır."
  type        = bool
  default     = false
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
