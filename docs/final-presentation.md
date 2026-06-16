# Final Presentation Script - 35 Minutes

## Section 1: Architecture Overview (5 min)
Show docs/architecture.md
Key points:
- Source: SQL Server 2022 Developer in Docker simulates on-prem
- Method: Managed Instance Link row 10 toughest online method
- DR: Distributed AG row 11 cross-region replication
- Zero data loss sub-minute failover

## Section 2: Repository Walkthrough (3 min)
Show GitHub repo structure explain each folder.

## Section 3: On-Prem Simulation (3 min)
Show running Docker containers: docker ps
Show databases and row counts in VS Code mssql extension.

## Section 4: Discovery (4 min)
Run: python3 discovery/db_dependency_crawler.py
Show output in discovery/inventory-output/

## Section 5: MI Link Setup (8 min)
Show Azure Portal MI Link configuration
Show replication status Synchronized
Explain Always On AG under the hood

## Section 6: Validation (5 min)
Run reconciliation and smoke tests
Show all PASS

## Section 7: CI/CD Pipeline (4 min)
Show GitHub Actions pipeline
Explain 7 jobs: build scan push precheck validate cutover rollback

## Section 8: Cutover (3 min)
Show cutover.sh human-gated type CUTOVER
Show App Service connection strings switching to MI

## Section 9: Distributed AG (3 min)
Explain cross-region DR setup
Show secondary MI in East Asia
Explain automatic failover less than 1 minute

## Q&A Preparation
- Why MI Link over DMS? Enterprise feature no extra cost real-time
- Why Distributed AG? Cross-region DR row 11 from migration chart
- What is RPO/RTO? Near zero RPO less than 1 min RTO with Distributed AG
- How scale to 200 DBs? Wave classifier plus parameterised scripts
