import os

files = {
    ".gitignore": ".env\n.env.*\n*.log\n*.bak\n__pycache__/\n*.pyc\n.DS_Store\nbaselines/\n",
    ".env.example": "SQL_SRC_HOST=localhost\nSQL_SRC_PORT=1433\nSQL_SRC_USER=sa\nSQL_SRC_PASSWORD=SourceDB@12345\nSQL_MI_FQDN=your-sqlmi.database.windows.net\nAZURE_RESOURCE_GROUP=rg-eshop-migration\n",
    "repos-used.md": "# Repositories Used\n\nPrimary: NimblePros/eShopOnWeb\nMethod: Managed Instance Link\n",
}

for filepath, content in files.items():
    with open(filepath, "w") as f:
        f.write(content)
    print(f"Created: {filepath}")

print("Done!")
