-- SQL Server Discovery Inventory
-- Run against source SQL Server before migration

-- 1. Server metadata
SELECT SERVERPROPERTY('ServerName') AS ServerName,
       SERVERPROPERTY('Edition') AS Edition,
       SERVERPROPERTY('ProductVersion') AS Version,
       SERVERPROPERTY('Collation') AS Collation;

-- 2. Database inventory
SELECT name, state_desc, recovery_model_desc, compatibility_level
FROM sys.databases WHERE database_id > 4;

-- 3. Table row counts
SELECT s.name AS SchemaName, t.name AS TableName, p.rows AS RowCount
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.indexes i ON i.object_id = t.object_id AND i.index_id <= 1
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id = i.index_id
ORDER BY p.rows DESC;

-- 4. Objects inventory
SELECT type_desc, name FROM sys.objects
WHERE type IN ('P','FN','TF','V','TR') ORDER BY type_desc, name;

-- 5. DMA compatibility checks
SELECT 'CLR Assemblies' AS Feature, COUNT(*) AS Count FROM sys.assemblies WHERE is_user_defined = 1
UNION ALL SELECT 'Linked Servers', COUNT(*) FROM sys.linked_servers
UNION ALL SELECT 'SQL Agent Jobs', COUNT(*) FROM msdb.dbo.sysjobs
UNION ALL SELECT 'Service Broker', COUNT(*) FROM sys.databases
WHERE is_broker_enabled = 1 AND database_id > 4;
