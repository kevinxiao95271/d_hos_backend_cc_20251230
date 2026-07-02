import paramiko, sys
sys.stdout.reconfigure(encoding='utf-8')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', port=22, username='root', password='Yiguo9527_', timeout=10)

def run(cmd):
    _, o, e = ssh.exec_command(cmd, timeout=15)
    return (o.read() + e.read()).decode('utf-8', 'replace')

# 查 report/export 相关错误
print(run("grep -A 15 'report.*export\\|exportWord\\|ReportWordBuilder\\|系统异常' /opt/hos_backend/app.log | tail -50"))
ssh.close()
