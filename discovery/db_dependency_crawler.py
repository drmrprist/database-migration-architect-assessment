#!/usr/bin/env python3
import os, re, json
from datetime import datetime

PATTERNS = {
    'mssql_connstr': r'Server=([^;]+);.*?Database=([^;]+)',
    'env_var': r'(?:DB_HOST|SQL_HOST|CONNECTION_STRING)=["\']?([^"\'\'\s]+)',
    'ef_context': r'DbContext|DbSet|OnConfiguring|UseSqlServer',
    'docker_service': r'image:\s*(mcr\.microsoft\.com/mssql|mysql|postgres)',
}

def crawl(root='.'):
    results = {'scan_time': datetime.utcnow().isoformat(), 'findings': []}
    for dirpath, _, files in os.walk(root):
        if any(x in dirpath for x in ['.git', 'node_modules', '__pycache__', 'bin', 'obj']):
            continue
        for fname in files:
            if not any(fname.endswith(ext) for ext in ['.cs','.json','.yml','.yaml','.env','.py','.sql']):
                continue
            fpath = os.path.join(dirpath, fname)
            try:
                content = open(fpath).read()
                for pattern_name, pattern in PATTERNS.items():
                    matches = re.findall(pattern, content, re.IGNORECASE)
                    if matches:
                        results['findings'].append({'file': fpath, 'pattern': pattern_name, 'matches': matches[:3]})
            except:
                pass
    return results

if __name__ == '__main__':
    os.makedirs('discovery/inventory-output', exist_ok=True)
    results = crawl('.')
    with open('discovery/inventory-output/app_inventory.json', 'w') as f:
        json.dump(results, f, indent=2)
    print(f"Scan complete. {len(results['findings'])} findings.")
    print('Output: discovery/inventory-output/app_inventory.json')
