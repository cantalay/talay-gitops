resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "gitops"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.7.1"

  atomic  = true
  wait    = true
  timeout = 1200

  values = [yamlencode({
    global = {
      domain            = var.domain
      priorityClassName = "talay-platform-critical"
    }
    configs = {
      cm = merge({
        "admin.enabled" = true
        url             = "https://${var.domain}"
        }, var.oidc_enabled ? {
        "oidc.config" = yamlencode({
          name                     = "Keycloak"
          issuer                   = var.keycloak_issuer
          clientID                 = "talay-argocd"
          enablePKCEAuthentication = true
          requestedScopes          = ["openid", "profile", "email"]
        })
      } : {})
      params = { "server.insecure" = true }
      rbac = {
        "policy.default" = "role:readonly"
        "policy.csv"     = "g, talay-platform-admins, role:admin"
        scopes           = "[groups]"
      }
    }
    dex = { enabled = false }
    controller = {
      replicas = 1
      metrics  = { enabled = true, serviceMonitor = { enabled = true } }
      resources = {
        requests = { cpu = "50m", memory = "256Mi" }
        limits   = { memory = "768Mi" }
      }
    }
    server = {
      replicas = 1
      ingress = {
        enabled          = true
        controller       = "generic"
        ingressClassName = "traefik"
        hostname         = var.domain
        tls              = true
        annotations      = { "cert-manager.io/cluster-issuer" = "letsencrypt" }
      }
      metrics = { enabled = true, serviceMonitor = { enabled = true } }
      resources = {
        requests = { cpu = "25m", memory = "128Mi" }
        limits   = { memory = "384Mi" }
      }
    }
    repoServer = {
      replicas = 1
      metrics  = { enabled = true, serviceMonitor = { enabled = true } }
      startupProbe = {
        enabled             = true
        failureThreshold    = 180
        initialDelaySeconds = 10
        periodSeconds       = 5
        timeoutSeconds      = 5
      }
      readinessProbe = {
        enabled          = true
        failureThreshold = 6
        periodSeconds    = 10
        timeoutSeconds   = 5
      }
      livenessProbe = {
        enabled          = true
        failureThreshold = 6
        periodSeconds    = 10
        timeoutSeconds   = 5
      }
      resources = {
        requests = { cpu = "25m", memory = "128Mi" }
        limits   = { memory = "512Mi" }
      }
    }
    applicationSet = {
      replicas = 1
      metrics  = { enabled = true, serviceMonitor = { enabled = true } }
    }
    redis = { metrics = { enabled = true, serviceMonitor = { enabled = true } } }
    notifications = {
      enabled = true
      metrics = { enabled = true, serviceMonitor = { enabled = true } }
    }
  })]
}
