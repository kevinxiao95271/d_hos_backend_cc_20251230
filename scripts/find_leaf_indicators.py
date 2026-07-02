import sys, paramiko
sys.stdout.reconfigure(encoding='utf-8')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

# 查叶子指标
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e \""
    "SELECT metric_code, metric_name, calculation_type, status, is_leaf, related_items "
    "FROM t_indicator WHERE is_leaf=1 AND status=1 LIMIT 20\\G\" 2>/dev/null"
)
print("=== 叶子指标（is_leaf=1, status=1） ===")
print(out.read().decode('utf-8', errors='replace'))

# 查是否有 result 数据
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e \""
    "SELECT metric_code, time_dimension, time_value, result_value "
    "FROM t_indicator_result ORDER BY create_time DESC LIMIT 10\" 2>/dev/null"
)
print("=== 已有计算结果（最近10条） ===")
print(out.read().decode('utf-8', errors='replace'))

# GRP_SURGERY 是父节点，找它的子节点
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e \""
    "SELECT metric_code,metric_name,is_leaf,parent_code FROM t_indicator WHERE parent_code='GRP_SURGERY'\" 2>/dev/null"
)
print("=== GRP_SURGERY 的子指标 ===")
print(out.read().decode('utf-8', errors='replace'))
ssh.close()
