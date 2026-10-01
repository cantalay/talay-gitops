resource "helm_release" "platform_root" {
  name      = "talay-platform-root"
  namespace = "gitops"
  chart     = "${path.module}/charts/platform-root"

  atomic  = true
  wait    = true
  timeout = 300

  values = [yamlencode({
    environmentsRepo = {
      url      = var.environments_repo_url
      revision = var.git_revision
    }
    chartsRepo = {
      url      = var.charts_repo_url
      revision = var.git_revision
    }
  })]
}
