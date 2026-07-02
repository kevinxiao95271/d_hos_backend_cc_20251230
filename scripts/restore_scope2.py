"""
通过 SSH 在服务器上执行 MySQL 直接恢复 rate_incision_infection 科室绑定
"""
import sys, paramiko
sys.stdout.reconfigure(encoding='utf-8')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

# 1. 查当前绑定状态
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ hos_indicator -e "
    "\"SELECT COUNT(*) FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
)
print("当前绑定数:", out.read().decode('utf-8','replace').strip())

# 2. 查所有科室 ID
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ hos_indicator -e "
    "\"SELECT dept_id, dept_name FROM t_dept WHERE status=1 ORDER BY dept_id;\" 2>/dev/null"
)
depts_raw = out.read().decode('utf-8','replace')
print("科室列表:\n", depts_raw)

# 3. 以 rate_surgery_complication 的绑定作为参考来恢复（它们应该绑定一样的科室）
restore_sql = """
INSERT IGNORE INTO t_indicator_dept_scope (metric_code, dept_id, is_primary_owner, create_time, update_time)
SELECT 'rate_incision_infection', dept_id, is_primary_owner, NOW(), NOW()
FROM t_indicator_dept_scope
WHERE metric_code = 'rate_surgery_complication';
"""
_, out, err = ssh.exec_command(
    f"mysql -u root -pYiguo9527_ hos_indicator -e \"{restore_sql}\" 2>&1"
)
print("恢复执行:", out.read().decode('utf-8','replace'), err.read().decode('utf-8','replace'))

# 4. 如果 surgery 也没有绑定, 用全部科室
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ hos_indicator -e "
    "\"SELECT COUNT(*) FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
)
cnt = out.read().decode('utf-8','replace').strip()
print("恢复后 rate_incision_infection 绑定数:", cnt)

# 如果还是 0，用所有科室
if '0' in cnt:
    print("rate_surgery_complication 也没绑定，改用全部科室...")
    restore_all_sql = """
    INSERT IGNORE INTO t_indicator_dept_scope (metric_code, dept_id, is_primary_owner, create_time, update_time)
    SELECT 'rate_incision_infection', dept_id, 1, NOW(), NOW()
    FROM t_dept WHERE status = 1;
    """
    _, out, err = ssh.exec_command(
        f"mysql -u root -pYiguo9527_ hos_indicator -e \"{restore_all_sql}\" 2>&1"
    )
    print("全科室恢复:", out.read().decode(), err.read().decode())

_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ hos_indicator -e "
    "\"SELECT COUNT(*) FROM t_indicator_dept_scope WHERE metric_code='rate_incision_infection';\" 2>/dev/null"
)
print("最终绑定数:", out.read().decode('utf-8','replace').strip())

ssh.close()
