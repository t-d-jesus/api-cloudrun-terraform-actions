output "api_url" {
  value       = google_cloud_run_v2_service.api_ts.uri
  description = "A URL pública da sua API"
}