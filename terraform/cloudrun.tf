resource "google_artifact_registry_repository" "api_repo" {
  location      = var.region
  repository_id = "api-repo"
  format        = "DOCKER"
  depends_on = [
    google_project_service.apis,
    google_sql_database_instance.postgres,
    google_secret_manager_secret_version.db_password_version
  ]
}

resource "google_cloud_run_v2_service" "api_ts" {
  name     = "api-ts-app"
  location = var.region

  template {
    service_account = "api-ts-runner@${var.project_id}.iam.gserviceaccount.com"

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" 
      
      env {
        name  = "DB_PASSWORD_SECRET_ID"
        value = google_secret_manager_secret.db_password_secret.id
      }
    }
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