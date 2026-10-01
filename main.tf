module "argocd" {
  source = "./modules/argocd"

  domain          = var.argocd_domain
  oidc_enabled    = var.oidc_enabled
  keycloak_issuer = var.keycloak_issuer
}

module "platform_root" {
  source = "./modules/platform-root"

  environments_repo_url = var.environments_repo_url
  charts_repo_url       = var.charts_repo_url
  git_revision          = var.git_revision

  depends_on = [module.argocd]
}

moved {
  from = helm_release.argocd
  to   = module.argocd.helm_release.argocd
}

moved {
  from = helm_release.platform_root
  to   = module.platform_root.helm_release.platform_root
}
