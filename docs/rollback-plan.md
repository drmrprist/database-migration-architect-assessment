# Rollback Plan

## Automated Rollback
CI/CD pipeline triggers rollback automatically on cutover failure.

## Manual Rollback
export AZURE_RESOURCE_GROUP=rg-eshop-migration
export APP_SERVICE_NAME=app-eshop-migration
export SQL_SRC_HOST=localhost
export SQL_SRC_PASSWORD=SourceDB@12345
bash migration/sqlserver/rollback_to_source.sh

## Source Retention Policy

| Phase | Action |
|-------|--------|
| 0-7 days post-cutover | Keep source running read-only |
| 7-30 days | Stop container retain image |
| 30+ days | Decommission after review |
