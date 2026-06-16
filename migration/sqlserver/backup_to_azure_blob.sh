#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_STORAGE_ACCOUNT:?Set AZURE_STORAGE_ACCOUNT}"
: "${AZURE_STORAGE_CONTAINER:?Set AZURE_STORAGE_CONTAINER}"
: "${SQL_SRC_PASSWORD:=SourceDB@12345}"

echo 'Generating SAS token...'
EXPIRY=$(date -u -v+24H +%Y-%m-%dT%H:%MZ 2>/dev/null || date -u -d '+24 hours' +%Y-%m-%dT%H:%MZ)
SAS=$(az storage container generate-sas \
  --account-name "$AZURE_STORAGE_ACCOUNT" \
  --name "$AZURE_STORAGE_CONTAINER" \
  --permissions rwdl --expiry "$EXPIRY" --output tsv)
BLOB_URL="https://${AZURE_STORAGE_ACCOUNT}.blob.core.windows.net/${AZURE_STORAGE_CONTAINER}"

echo 'Backing up CatalogDb...'
docker exec sqlserver-source /opt/mssql-tools18/bin/sqlcmd \
  -S localhost,1433 -U sa -P "$SQL_SRC_PASSWORD" -C -Q "
BACKUP DATABASE [Microsoft.eShopOnWeb.CatalogDb]
TO URL = '${BLOB_URL}/catalogdb_full.bak'
WITH FORMAT, COMPRESSION, CHECKSUM, STATS=10;"

echo 'Backing up Identity...'
docker exec sqlserver-source /opt/mssql-tools18/bin/sqlcmd \
  -S localhost,1433 -U sa -P "$SQL_SRC_PASSWORD" -C -Q "
BACKUP DATABASE [Microsoft.eShopOnWeb.Identity]
TO URL = '${BLOB_URL}/identity_full.bak'
WITH FORMAT, COMPRESSION, CHECKSUM, STATS=10;"

echo 'Backup complete!'
