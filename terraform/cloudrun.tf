resource "google_artifact_registry_repository" "api_repo" {
  location      = var.region
  repository_id = "api-repo"
  format        = "DOCKER"
  depends_on    = [google_project_service.apis]
}

resource "google_cloud_run_v2_service" "api_ts" {
  name                = "api-ts-app"
  location            = var.region
  deletion_protection = false  

  depends_on = [
    google_project_service.apis,
    google_sql_database_instance.postgres,
    google_secret_manager_secret_version.db_password_version
  ]

  template {
    service_account = "api-ts-runner@${var.project_id}.iam.gserviceaccount.com"

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "REGION"
        value = var.region
      }
      env {
        name  = "NODE_ENV"
        value = "production"
      }
      
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password_secret.id
            version = "latest"
          }
        }
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.postgres.connection_name]
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  name     = google_cloud_run_v2_service.api_ts.name
  location = google_cloud_run_v2_service.api_ts.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "api_url" {
  value       = google_cloud_run_v2_service.api_ts.uri
  description = "URL principal da sua API"
}