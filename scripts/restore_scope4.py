import sys, paramiko
sys.stdout.reconfigure(encoding='utf-8')

DB = 'gz-cdb-bq7gk3k5.sql.tencentcdb.com'
mysql_cmd = f"mysql -h {DB} -P 63606 -u root -p'Yiguo9527_' d_hos_claude_0251230"

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

# 查表结构
for tbl in ['t_indicator_dept_scope', 't_dept']:
    _, out, _ = ssh.exec_command(f"{mysql_cmd} -e \"DESCRIBE {tbl};\" 2>/dev/null")
    print(f"\n=== {tbl} ===")
    print(out.read().decode('utf-8', 'replace'))

# 查 scope 表已有哪些 metric_code
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT metric_code, COUNT(*) as cnt FROM t_indicator_dept_scope GROUP BY metric_code ORDER BY cnt DESC LIMIT 10;\" 2>/dev/null"
)
print("\n=== scope 表指标绑定统计 ===")
print(out.read().decode('utf-8', 'replace'))

ssh.close()
