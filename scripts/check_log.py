import paramiko, sys
sys.stdout.reconfigure(encoding='utf-8')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', port=22, username='root', password='Yiguo9527_', timeout=10)

def run(cmd):
    _, o, e = ssh.exec_command(cmd, timeout=15)
    return (o.read() + e.read()).decode('utf-8', 'replace')

# 看最新日志
print("=== 最新20行日志 ===")
print(run("tail -20 /opt/hos_backend/app.log"))

# 查端口状态
print("\n=== 端口8070 ===")
print(run("ss -tlnp | grep 8070"))

ssh.close()
