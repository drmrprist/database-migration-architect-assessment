#!/usr/bin/env bash
set -euo pipefail
: "${PG_SRC_HOST:=localhost}"
: "${PG_SRC_PASSWORD:?Set PG_SRC_PASSWORD}"
: "${PG_SRC_DB:=petclinic}"
: "${PG_TGT_HOST:?Set PG_TGT_HOST}"
: "${PG_TGT_PASSWORD:?Set PG_TGT_PASSWORD}"
: "${PG_TGT_DB:=petclinic}"

echo 'Dumping PostgreSQL source...'
PGPASSWORD=$PG_SRC_PASSWORD pg_dump -h $PG_SRC_HOST -U $PG_SRC_USER \
  -d $PG_SRC_DB --format=custom --compress=9 --no-owner -f /tmp/pg_dump.custom

echo 'Restoring to Azure PostgreSQL Flexible Server...'
PGPASSWORD=$PG_TGT_PASSWORD pg_restore -h $PG_TGT_HOST -U $PG_TGT_USER \
  -d $PG_TGT_DB --clean --if-exists --jobs=4 /tmp/pg_dump.custom

echo 'PostgreSQL migration complete!'
