output "api_url" {
  description = "A URL pública gerada pelo Cloud Run"
  value       = google_cloud_run_v2_service.api_ts.uri
}

output "db_connection_name" {
  description = "O nome da conexão do banco de dados"
  value       = google_sql_database_instance.postgres_instance.connection_name
}