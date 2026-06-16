# Cutover Runbook

## Pre-Cutover Checklist
- [ ] SQL MI provisioned and accessible
- [ ] Both databases replicated to MI
- [ ] MI Link status: Synchronized
- [ ] App Service staging slot validated
- [ ] Key Vault secrets updated
- [ ] Rollback plan reviewed
- [ ] Stakeholders notified

## Cutover Steps

### Step 1 - Verify replication
az sql mi link show --resource-group rg-eshop-migration --instance-name sqlmi-eshop-dev --name eshop-link

### Step 2 - Run cutover script
bash migration/sqlserver/cutover.sh
Type CUTOVER when prompted.

### Step 3 - Validate
python3 validation/reconciliation.py --tgt-host SQL_MI_FQDN --tgt-pwd SQL_MI_PASSWORD
bash validation/smoke_test.sh

### Step 4 - Confirm or rollback
- All PASS -> announce cutover complete
- Any FAIL -> run rollback_to_source.sh immediately

## Rollback Triggers
- Health check fails after 10 attempts
- Row count mismatch detected
- Smoke test returns 5xx errors
- App logs show connection errors

## Rollback Command
bash migration/sqlserver/rollback_to_source.sh
