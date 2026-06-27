import paramiko, time

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', port=22, username='root', password='Yiguo9527_', timeout=15)

def run(cmd):
    _, o, e = ssh.exec_command(cmd, timeout=30)
    out = o.read().decode('utf-8', 'replace').strip()
    err = e.read().decode('utf-8', 'replace').strip()
    return out or err or '(empty)'

# 强制杀掉 711422
print("杀进程 711422")
print(run("kill -9 711422"))
time.sleep(3)

# 再确认
chk = run("ss -tlnp | grep 8070")
print("8070状态:", chk or "port free")

if '8070' in chk:
    # 还有进程，用fuser
    print("用fuser杀:")
    print(run("fuser -k 8070/tcp"))
    time.sleep(3)

print("启动新JAR...")
cmd = "nohup java -jar /opt/hos_backend/indicator-management.jar --server.port=8070 > /opt/hos_backend/app.log 2>&1 &"
print(run(cmd))
print("等待25秒...")
time.sleep(25)

print("检查8070:")
print(run("ss -tlnp | grep 8070"))
print("日志尾部:")
print(run("tail -15 /opt/hos_backend/app.log"))
ssh.close()
