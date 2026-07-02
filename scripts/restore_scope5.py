import sys, paramiko
sys.stdout.reconfigure(encoding='utf-8')

DB = 'gz-cdb-bq7gk3k5.sql.tencentcdb.com'
mysql_cmd = f"mysql -h {DB} -P 63606 -u root -p'Yiguo9527_' d_hos_claude_0251230"

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

# 查 rate_surgery_complication 和 rate_incision_infection 的绑定
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT metric_code, COUNT(*) FROM t_indicator_dept_scope "
    f"WHERE metric_code IN ('rate_surgery_complication','rate_incision_infection') GROUP BY metric_code;\" 2>/dev/null"
)
print("两个指标当前绑定:")
print(out.read().decode('utf-8','replace'))

# 用 avg_cost_pneumonia_adult 的 106 个 root_dept_id 恢复两个被删的指标
for metric in ['rate_incision_infection', 'rate_surgery_complication']:
    _, out, _ = ssh.exec_command(
        f"{mysql_cmd} -e \"SELECT COUNT(*) FROM t_indicator_dept_scope WHERE metric_code='{metric}';\" 2>/dev/null"
    )
    cnt = out.read().decode('utf-8','replace')
    if '0' in cnt:
        restore_sql = (
            f"INSERT IGNORE INTO t_indicator_dept_scope (metric_code, root_dept_id, is_primary_owner, create_time) "
            f"SELECT '{metric}', root_dept_id, is_primary_owner, NOW() "
            f"FROM t_indicator_dept_scope WHERE metric_code='avg_cost_pneumonia_adult';"
        )
        _, out2, err2 = ssh.exec_command(f"{mysql_cmd} -e \"{restore_sql}\" 2>&1")
        print(f"恢复 {metric}:", out2.read().decode(), err2.read().decode())
    else:
        print(f"{metric} 已有绑定: {cnt.strip()}")

# 最终确认
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT metric_code, COUNT(*) as cnt FROM t_indicator_dept_scope "
    f"WHERE metric_code IN ('rate_surgery_complication','rate_incision_infection') GROUP BY metric_code;\" 2>/dev/null"
)
print("最终绑定情况:")
print(out.read().decode('utf-8','replace'))

ssh.close()
print("完成")
