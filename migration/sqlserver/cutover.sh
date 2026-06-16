#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_RESOURCE_GROUP:?Set AZURE_RESOURCE_GROUP}"
: "${APP_SERVICE_NAME:?Set APP_SERVICE_NAME}"
: "${SQL_MI_FQDN:?Set SQL_MI_FQDN}"
: "${SQL_MI_PASSWORD:?Set SQL_MI_PASSWORD}"

echo '=== CUTOVER STARTING ==='
if [[ "${AUTO_APPROVE:-false}" != 'true' ]]; then
    read -p 'Type CUTOVER to proceed: ' confirm
    [[ "$confirm" != 'CUTOVER' ]] && echo 'Aborted.' && exit 1
fi

echo 'Stopping App Service...'
az webapp stop --resource-group "$AZURE_RESOURCE_GROUP" --name "$APP_SERVICE_NAME"

echo 'Switching connection strings to SQL MI...'
az webapp config connection-string set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$APP_SERVICE_NAME" \
  --connection-string-type SQLServer \
  --settings \
    "CatalogConnection=Server=${SQL_MI_FQDN},3342;Database=Microsoft.eShopOnWeb.CatalogDb;User Id=sqladmin;Password=${SQL_MI_PASSWORD};TrustServerCertificate=True;" \
    "IdentityConnection=Server=${SQL_MI_FQDN},3342;Database=Microsoft.eShopOnWeb.Identity;User Id=sqladmin;Password=${SQL_MI_PASSWORD};TrustServerCertificate=True;"

echo 'Starting App Service...'
az webapp start --resource-group "$AZURE_RESOURCE_GROUP" --name "$APP_SERVICE_NAME"

echo 'Health check...'
APP_URL=$(az webapp show --resource-group "$AZURE_RESOURCE_GROUP" --name "$APP_SERVICE_NAME" --query defaultHostName -o tsv)
for i in $(seq 1 10); do
    code=$(curl -s -o /dev/null -w "%{http_code}" "https://${APP_URL}/health" --max-time 10 || echo '000')
    [[ "$code" == '200' ]] && echo 'Health check passed!' && break
    echo "Attempt $i/10 returned $code, waiting 15s..."
    sleep 15
done
echo '=== CUTOVER COMPLETE ==='
