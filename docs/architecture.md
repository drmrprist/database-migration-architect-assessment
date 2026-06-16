# Architecture -- eShopOnWeb SQL Server to Azure SQL MI

## Executive Summary
End-to-end migration of eShopOnWeb .NET monolith from on-prem SQL Server
to Azure SQL MI using Managed Instance Link for online replication.

## Architecture
MacBook Docker (On-Prem Simulation)
SQL Server 2022 Developer Edition
  - Microsoft.eShopOnWeb.CatalogDb
  - Microsoft.eShopOnWeb.Identity
      |
      | Phase 1: Managed Instance Link
      v
Primary Azure SQL MI (Southeast Asia)
      |
      | Phase 2: Distributed AG
      v
Secondary Azure SQL MI (East Asia)

## Migration Methods

| Method | Row | Purpose |
|--------|-----|---------|
| Managed Instance Link | Row 10 | Online migration SQL Server to MI |
| Distributed AG | Row 11 | Cross-region DR between two MIs |
| LRS fallback | Row 9 | Offline baseline if MI Link unavailable |

## HA/DR Design

| Tier | Method | RTO | RPO |
|------|--------|-----|-----|
| Zone failure | MI built-in 3 replicas | less than 30s | 0 |
| Region failure | Distributed AG failover | less than 1 min | 0 |
| Accidental deletion | Point-in-time restore | 20-30 min | 5-12 min |

## Wave Plan

| Wave | DB Size | Method | Downtime |
|------|---------|--------|----------|
| 1 | less than 10 GB | LRS offline | 1-2 hours |
| 2 | 10-100 GB | Azure DMS online | less than 30 min |
| 3 | 100 GB to 35 TB | MI Link or Distributed AG | less than 5 min |

## Secret Management
- No plaintext credentials in repository
- Azure Key Vault for all connection strings
- Managed Identity for App Service
- GitHub Actions OIDC for pipeline authentication
