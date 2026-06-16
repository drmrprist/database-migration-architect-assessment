USE master;
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Microsoft.eShopOnWeb.CatalogDb')
    CREATE DATABASE [Microsoft.eShopOnWeb.CatalogDb] COLLATE SQL_Latin1_General_CP1_CI_AS;
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Microsoft.eShopOnWeb.Identity')
    CREATE DATABASE [Microsoft.eShopOnWeb.Identity] COLLATE SQL_Latin1_General_CP1_CI_AS;
GO
PRINT '=== Databases created ===';
