# Migration Assessment Report

## Source Environment
- SQL Server 2022 Developer Edition (Docker)
- Databases: Microsoft.eShopOnWeb.CatalogDb, Microsoft.eShopOnWeb.Identity
- ORM: Entity Framework Core (code-first)
- No CLR, no linked servers, no SQL Agent jobs

## Compatibility Assessment

| Feature | Azure SQL DB | Azure SQL MI | Finding |
|---------|-------------|-------------|--------|
| Cross-DB queries | No | Yes | MI required |
| Instance logins | No | Yes | MI required |
| Native backup | No | Yes | MI required |
| CLR | No | Yes | Not used |
| SQL Agent | No | Yes | Not used |

## Decision: Azure SQL Managed Instance
Cross-database dependency between CatalogDb and Identity requires MI.

## Migration Method Selection

| Method | Selected | Reason |
|--------|----------|--------|
| Managed Instance Link | Yes (primary) | Online, real-time, no extra cost |
| Distributed AG | Yes (DR) | Cross-region replication |
| LRS | Fallback | Offline baseline if needed |
| Azure DMS | No | MI Link preferred for same platform |

## Sizing
| Parameter | Value |
|-----------|-------|
| vCores | 4 (GP_Gen5_4) |
| Storage | 32 GB minimum |
| Tier | General Purpose |
| Backup | Geo-redundant (GRS) |

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Network tunnel instability | Medium | High | Azure SQL VM as source alternative |
| MI provisioning time 4-6hrs | High | Low | Provision in advance |
| EF migrations on startup | Low | Medium | Test in staging first |
| Data divergence on rollback | Low | High | Freeze window minimises exposure |
