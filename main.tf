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
      domain            = var.argocd_domain
      priorityClassName = "talay-platform-critical"
    }
    configs = {
      cm = {
        "admin.enabled" = true
        url             = "https://${var.argocd_domain}"
        "oidc.config" = yamlencode({
          name                     = "Keycloak"
          issuer                   = var.keycloak_issuer
          clientID                 = "talay-argocd"
          enablePKCEAuthentication = true
          requestedScopes          = ["openid", "profile", "email"]
        })
      }
      params = {
        "server.insecure" = true
      }
      rbac = {
        "policy.default" = "role:readonly"
        "policy.csv"     = "g, talay-platform-admins, role:admin"
        scopes           = "[groups]"
      }
    }
    controller = {
      replicas = 1
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
      resources = {
        requests = {
          cpu    = "100m"
          memory = "256Mi"
        }
        limits = {
          memory = "768Mi"
        }
      }
    }
    server = {
      replicas = 1
      ingress = {
        enabled          = true
        controller       = "generic"
        ingressClassName = "traefik"
        hostname         = var.argocd_domain
        tls              = true
        annotations = {
          "cert-manager.io/cluster-issuer" = "letsencrypt"
        }
      }
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
      resources = {
        requests = {
          cpu    = "50m"
          memory = "128Mi"
        }
        limits = {
          memory = "384Mi"
        }
      }
    }
    repoServer = {
      replicas = 1
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
      resources = {
        requests = {
          cpu    = "50m"
          memory = "128Mi"
        }
        limits = {
          memory = "512Mi"
        }
      }
    }
    applicationSet = {
      replicas = 1
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
    }
    redis = {
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
    }
    notifications = {
      enabled = true
      metrics = {
        enabled = true
        serviceMonitor = {
          enabled = true
        }
      }
    }
  })]
}

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

  depends_on = [helm_release.argocd]
}
