resource "google_sql_database_instance" "postgres" {
  name             = "api-db-instance"
  database_version = "POSTGRES_15"
  region           = var.region
  depends_on = [google_project_service.apis]
  settings {
    tier = "db-f1-micro" 
  }
  deletion_protection = false
}

resource "google_sql_user" "db_user" {
  name     = "api_user"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "db-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = var.db_password
}