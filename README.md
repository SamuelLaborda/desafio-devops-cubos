# Desafio Técnico - DevOps

Stack: **Terraform + Docker + Nginx + Node.js + PostgreSQL 15.8**

## Requisitos/Dependências
- Docker 24+ e Docker Engine em execução
- Terraform 1.6+ 
- Porta `8080` livre no host (ajustável em `terraform.tfvars`)

## Estrutura
- `frontend/`: HTML e Nginx (proxy /api -> backend)
- `backend/`: Node.js com index.js
- `db/`: init.sql (tabela users + seed admin)
- `terraform/`: IaC com provider Docker

## Inicialização
```bash
cd terraform
terraform init
terraform apply -auto-approve -var-file=terraform.tfvars
```

Acesse: [http://localhost:8080](http://localhost:8080)

## Encerramento
```bash
terraform destroy -auto-approve -var-file=terraform.tfvars
docker volume rm desafio-devops-pgdata
```