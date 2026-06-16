#!/usr/bin/env bash
set -euo pipefail
: "${MYSQL_SRC_HOST:=localhost}"
: "${MYSQL_SRC_PASSWORD:?Set MYSQL_SRC_PASSWORD}"
: "${MYSQL_SRC_DB:=petclinic}"
: "${MYSQL_TGT_HOST:?Set MYSQL_TGT_HOST}"
: "${MYSQL_TGT_PASSWORD:?Set MYSQL_TGT_PASSWORD}"
: "${MYSQL_TGT_DB:=petclinic}"

echo 'Dumping MySQL source...'
mysqldump --host=$MYSQL_SRC_HOST --user=root --password=$MYSQL_SRC_PASSWORD \
  --single-transaction --routines --triggers --set-gtid-purged=OFF \
  $MYSQL_SRC_DB > /tmp/mysql_dump.sql

echo 'Restoring to Azure MySQL Flexible Server...'
mysql --host=$MYSQL_TGT_HOST --user=$MYSQL_TGT_USER \
  --password=$MYSQL_TGT_PASSWORD --ssl-mode=REQUIRED \
  $MYSQL_TGT_DB < /tmp/mysql_dump.sql

echo 'MySQL migration complete!'
