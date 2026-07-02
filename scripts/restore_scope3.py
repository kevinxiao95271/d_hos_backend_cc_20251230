"""
通过腾讯云 MySQL 地址 + SSH 隧道恢复 rate_incision_infection 的科室绑定
数据库: gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606  库名: d_hos_claude_0251230
"""
import sys, paramiko, time
sys.stdout.reconfigure(encoding='utf-8')

DB_HOST = 'gz-cdb-bq7gk3k5.sql.tencentcdb.com'
DB_PORT = 63606
DB_NAME = 'd_hos_claude_0251230'
DB_USER = 'root'
DB_PASS = 'Yiguo9527_'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

mysql_cmd = f"mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p'{DB_PASS}' {DB_NAME}"

# 1. 当前绑定数
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT COUNT(*) as cnt FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
)
print("当前 rate_incision_infection 绑定数:")
print(out.read().decode('utf-8','replace'))

# 2. 查科室列表
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT dept_id, dept_name FROM t_dept WHERE del_flag=0 ORDER BY dept_id LIMIT 50;\" 2>/dev/null"
)
print("科室列表:")
depts_txt = out.read().decode('utf-8','replace')
print(depts_txt)

# 3. 以 rate_surgery_complication 的绑定为模板恢复
restore_sql = (
    "INSERT IGNORE INTO t_indicator_dept_scope "
    "(metric_code, dept_id, is_primary_owner, create_time, update_time) "
    "SELECT 'rate_incision_infection', dept_id, is_primary_owner, NOW(), NOW() "
    "FROM t_indicator_dept_scope "
    "WHERE metric_code = 'rate_surgery_complication';"
)
_, out, err = ssh.exec_command(
    f"{mysql_cmd} -e \"{restore_sql}\" 2>&1"
)
print("恢复（参照 rate_surgery_complication）:", out.read().decode(), err.read().decode())

# 4. 再查
_, out, _ = ssh.exec_command(
    f"{mysql_cmd} -e \"SELECT COUNT(*) as cnt FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
)
cnt_txt = out.read().decode('utf-8','replace')
print("恢复后绑定数:", cnt_txt)

# 5. 如果还是0，用全部科室
if '0' in cnt_txt and len(cnt_txt.strip()) < 5:
    print("rate_surgery_complication 也没绑定，改用全部科室...")
    restore_all = (
        "INSERT IGNORE INTO t_indicator_dept_scope "
        "(metric_code, dept_id, is_primary_owner, create_time, update_time) "
        "SELECT 'rate_incision_infection', dept_id, 1, NOW(), NOW() "
        "FROM t_dept WHERE del_flag=0;"
    )
    _, out, err = ssh.exec_command(
        f"{mysql_cmd} -e \"{restore_all}\" 2>&1"
    )
    print("全科室恢复:", out.read().decode(), err.read().decode())
    _, out, _ = ssh.exec_command(
        f"{mysql_cmd} -e \"SELECT COUNT(*) as cnt FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
    )
    print("最终绑定数:", out.read().decode('utf-8','replace'))

ssh.close()
print("完成")
