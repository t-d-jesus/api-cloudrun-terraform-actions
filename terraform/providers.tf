terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    # Os valores de 'bucket' e 'prefix' são passados no deploy.yml
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}