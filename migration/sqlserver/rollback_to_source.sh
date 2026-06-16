#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_RESOURCE_GROUP:?Set AZURE_RESOURCE_GROUP}"
: "${APP_SERVICE_NAME:?Set APP_SERVICE_NAME}"
: "${SQL_SRC_HOST:?Set SQL_SRC_HOST}"
: "${SQL_SRC_PASSWORD:?Set SQL_SRC_PASSWORD}"

echo 'Stopping App Service...'
az webapp stop --resource-group "$AZURE_RESOURCE_GROUP" --name "$APP_SERVICE_NAME"

echo 'Reverting connection strings to source...'
az webapp config connection-string set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$APP_SERVICE_NAME" \
  --connection-string-type SQLServer \
  --settings \
    "CatalogConnection=Server=${SQL_SRC_HOST},1433;Database=Microsoft.eShopOnWeb.CatalogDb;User Id=sa;Password=${SQL_SRC_PASSWORD};TrustServerCertificate=True;" \
    "IdentityConnection=Server=${SQL_SRC_HOST},1433;Database=Microsoft.eShopOnWeb.Identity;User Id=sa;Password=${SQL_SRC_PASSWORD};TrustServerCertificate=True;"

echo 'Starting App Service...'
az webapp start --resource-group "$AZURE_RESOURCE_GROUP" --name "$APP_SERVICE_NAME"
echo 'Rollback complete!'
