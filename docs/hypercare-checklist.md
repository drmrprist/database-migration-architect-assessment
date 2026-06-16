# 48-Hour Hypercare Checklist

## T+0 to T+1 Hour
- [ ] Health endpoint returns 200
- [ ] Catalog page loads with all 12 products
- [ ] Basket add works (write transaction)
- [ ] Admin login works
- [ ] No 5xx errors in App Service logs
- [ ] SQL MI CPU less than 50 percent
- [ ] Validation report all PASS

## T+1h to T+24h
- [ ] No alerts fired
- [ ] Query response times within 2x baseline
- [ ] No blocked queries or deadlocks
- [ ] Automated backup completed

## T+24h to T+48h
- [ ] Performance baseline comparison run
- [ ] UPDATE STATISTICS on key tables
- [ ] Rebuild indexes over 30 percent fragmentation
- [ ] Enable Query Store on both databases
- [ ] Disable MI public endpoint

## T+48h - Hypercare Close
- [ ] All checklist items complete
- [ ] No open incidents
- [ ] Source container stopped not deleted
- [ ] Sign-off email sent
