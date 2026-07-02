import sys, paramiko
sys.stdout.reconfigure(encoding='utf-8')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

def q(sql):
    _, out, _ = ssh.exec_command(
        f'mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e "{sql}" 2>/dev/null'
    )
    return out.read().decode('utf-8', errors='replace').strip()

print("=== TABLES ===")
print(q("SHOW TABLES"))

print("\n=== t_indicator count ===")
print(q("SELECT COUNT(*) as cnt FROM t_indicator"))

print("\n=== t_indicator (first 15) ===")
print(q("SELECT metric_code,metric_name,is_leaf,status FROM t_indicator LIMIT 15"))

print("\n=== is_leaf=1 indicators ===")
print(q("SELECT metric_code,metric_name,is_leaf,calculation_type FROM t_indicator WHERE is_leaf=1 LIMIT 10"))

print("\n=== GRP_SURGERY ===")
print(q("SELECT metric_code,metric_name,is_leaf,parent_code FROM t_indicator WHERE metric_code='GRP_SURGERY'"))

print("\n=== Children of GRP_SURGERY ===")
print(q("SELECT metric_code,metric_name,is_leaf FROM t_indicator WHERE parent_code='GRP_SURGERY'"))

print("\n=== Recent calc results ===")
print(q("SELECT metric_code,time_value,result_value FROM t_indicator_result ORDER BY create_time DESC LIMIT 10"))

ssh.close()
