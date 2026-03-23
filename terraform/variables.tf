variable "project_id" {
  type        = string
  description = "ID do projeto no GCP"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Região onde os recursos serão criados"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Senha do banco de dados vinda do GitHub Secrets"
}