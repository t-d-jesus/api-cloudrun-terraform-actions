provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = ">= 1.0"
  backend "gcs" {
    # Configurado dinamicamente via GitHub Actions
  }
}

resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = false
}