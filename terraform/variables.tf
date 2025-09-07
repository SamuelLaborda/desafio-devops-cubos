variable "project_name" {
  type    = string
  default = "desafio-devops"
}

variable "frontend_port" {
  type    = number
  default = 8080
}

variable "postgres_user" { type = string }
variable "postgres_password" { type = string }
variable "postgres_db" {
  type    = string
  default = "appdb"
}