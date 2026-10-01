output "argocd_url" {
  value = module.argocd.url
}

output "application_set" {
  value = module.platform_root.application_set
}
