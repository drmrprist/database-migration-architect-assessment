# Database Migration Architect Assessment

## eShopOnWeb (.NET) — SQL Server → Azure SQL MI via Managed Instance Link

End-to-end migration from on-prem SQL Server (Docker) to Azure SQL MI
using Managed Instance Link for online replication with near-zero downtime.

## Quick Start

```bash
# Start on-prem simulation
docker compose -f docker/docker-compose.onprem.yml up -d

# Verify app
curl http://localhost:8080/health
```

## Architecture
- Source: SQL Server 2022 Developer (Docker — simulates on-prem)
- Replication: Managed Instance Link (Always On AG)
- Target: Azure SQL Managed Instance (Southeast Asia)
- DR: Distributed AG → Secondary MI (East Asia)
- App: eShopOnWeb .NET 8 on Azure App Service
- CI/CD: GitHub Actions
- IaC: Bicep + Terraform
