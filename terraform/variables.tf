variable "project_id" {
  description = "O ID do projeto no Google Cloud"
  type        = string
}

variable "region" {
  description = "Região principal para os recursos"
  type        = string
  default     = "us-central1"
}

variable "db_password" {
  description = "Senha do usuário administrador do Postgres"
  type        = string
  sensitive   = true
}

variable "repository_id" {
  description = "Nome do repositório no Artifact Registry"
  type        = string
  default     = "api-repo"
}

variable "service_name" {
  description = "Nome do serviço no Cloud Run"
  type        = string
  default     = "api-ts-app"
}