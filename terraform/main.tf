terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app" {
  name = "${var.project_name}-net"
}

resource "docker_volume" "pgdata" {
  name = "${var.project_name}-pgdata"
}

resource "docker_image" "postgres" {
  name = "postgres:15.8"
  keep_locally = true
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app.name
  }

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.pgdata.name
    type   = "volume"
  }

  mounts {
    target    = "/docker-entrypoint-initdb.d/init.sql"
    source    = abspath("${path.module}/../db/init.sql")
    type      = "bind"
    read_only = true
  }
}

resource "docker_image" "backend" {
  name = "${var.project_name}-backend:latest"
  build {
    context    = "${path.module}/../backend"
    dockerfile = "Dockerfile"
  }
  keep_locally = true
}

resource "docker_container" "backend" {
  name   = "backend"
  image  = docker_image.backend.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app.name
  }

  env = [
    "port=3000",
    "user=${var.postgres_user}",
    "pass=${var.postgres_password}",
    "host=postgres",
    "db_port=5432",
    "PGDATABASE=${var.postgres_db}"
  ]

  depends_on = [docker_container.postgres]
}

resource "docker_image" "frontend" {
  name = "${var.project_name}-frontend:latest"
  build {
    context    = "${path.module}/../frontend"
    dockerfile = "Dockerfile"
  }
  keep_locally = true
}

resource "docker_container" "frontend" {
  name   = "frontend"
  image  = docker_image.frontend.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app.name
  }

  ports {
    internal = 80
    external = var.frontend_port
  }

  depends_on = [docker_container.backend]
}