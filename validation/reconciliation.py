#!/usr/bin/env python3
import sys, json
from datetime import datetime

def run_validation(src_host, src_port, src_user, src_pwd, tgt_host, tgt_port, tgt_user, tgt_pwd):
    try:
        import pyodbc
    except ImportError:
        import subprocess
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'pyodbc'])
        import pyodbc

    results = []
    timestamp = datetime.utcnow().isoformat()

    def connect(host, port, user, pwd):
        conn_str = f'DRIVER={ODBC Driver 18 for SQL Server};SERVER={host},{port};UID={user};PWD={pwd};TrustServerCertificate=yes'
        return pyodbc.connect(conn_str)

    checks = [
        ('CatalogBrands', 'Microsoft.eShopOnWeb.CatalogDb'),
        ('CatalogTypes',  'Microsoft.eShopOnWeb.CatalogDb'),
        ('Catalog',       'Microsoft.eShopOnWeb.CatalogDb'),
        ('AspNetUsers',   'Microsoft.eShopOnWeb.Identity'),
    ]

    src_conn = connect(src_host, src_port, src_user, src_pwd)
    tgt_conn = connect(tgt_host, tgt_port, tgt_user, tgt_pwd)

    for table, db in checks:
        src_cur = src_conn.cursor()
        tgt_cur = tgt_conn.cursor()
        src_cur.execute(f'SELECT COUNT(*) FROM [{db}].dbo.[{table}]')
        tgt_cur.execute(f'SELECT COUNT(*) FROM [{db}].dbo.[{table}]')
        src_count = src_cur.fetchone()[0]
        tgt_count = tgt_cur.fetchone()[0]
        status = 'PASS' if src_count == tgt_count else 'FAIL'
        results.append({'table': table, 'source': src_count, 'target': tgt_count, 'status': status})
        print(f'[{status}] {table}: source={src_count} target={tgt_count}')

    report = {'timestamp': timestamp, 'results': results}
    with open(f'validation-report-{timestamp[:10]}.json', 'w') as f:
        json.dump(report, f, indent=2)

    failures = [r for r in results if r['status'] == 'FAIL']
    if failures:
        print(f'[FAILED] {len(failures)} checks failed')
        sys.exit(1)
    else:
        print(f'[PASSED] All {len(results)} checks passed')

if __name__ == '__main__':
    import argparse
    p = argparse.ArgumentParser()
    p.add_argument('--src-host', default='localhost')
    p.add_argument('--src-port', default='1433')
    p.add_argument('--src-user', default='sa')
    p.add_argument('--src-pwd',  default='SourceDB@12345')
    p.add_argument('--tgt-host', required=True)
    p.add_argument('--tgt-port', default='3342')
    p.add_argument('--tgt-user', default='sqladmin')
    p.add_argument('--tgt-pwd',  required=True)
    args = p.parse_args()
    run_validation(args.src_host, args.src_port, args.src_user, args.src_pwd,
                   args.tgt_host, args.tgt_port, args.tgt_user, args.tgt_pwd)
