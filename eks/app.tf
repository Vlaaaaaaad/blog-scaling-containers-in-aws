resource "kubernetes_deployment" "app" {
  metadata {
    name      = "app"
    namespace = "default"

    labels = {
      "app.kubernetes.io/name"       = "app"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  spec {
    # replicas = 3500
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "app"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"       = "app"
          "app.kubernetes.io/managed-by" = "Terraform"
        }
      }

      spec {
        container {
          name  = "app"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/test-repo:latest"

          port {
            container_port = 5003
          }

          resources {
            limits {
              cpu    = "1"
              memory = "2Gi"
            }

            requests {
              cpu    = "1"
              memory = "2Gi"
            }
          }

          liveness_probe {
            http_get {
              path = "/status/alive"
              port = "5003"
            }
          }

          readiness_probe {
            http_get {
              path = "/status/alive"
              port = "5003"
            }
          }

          security_context {
            read_only_root_filesystem  = true
            privileged                 = false
            allow_privilege_escalation = false
          }

          image_pull_policy = "IfNotPresent"
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "nodegroup"
                  operator = "In"
                  values   = ["spot"]
                }
              }
            }
          }
        }
      }
    }
  }
}
