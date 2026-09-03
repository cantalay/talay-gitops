output "argocd_url" {
  value = "https://${var.argocd_domain}"
}

output "application_set" {
  value = "talay-applications"
}
