import paramiko, time

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', port=22, username='root', password='Yiguo9527_', timeout=15)

def run(cmd):
    _, o, e = ssh.exec_command(cmd, timeout=30)
    out = o.read().decode('utf-8', 'replace').strip()
    err = e.read().decode('utf-8', 'replace').strip()
    return out or err or '(empty)'

print("Step1: 杀旧进程 3842980")
print(run("kill -9 3842980"))
time.sleep(3)

print("Step2: 确认8070已释放")
chk = run("ss -tlnp | grep 8070")
print(chk if chk else "port free")

print("Step3: 启动新JAR")
cmd = "nohup java -jar /opt/hos_backend/indicator-management.jar --server.port=8070 > /opt/hos_backend/app.log 2>&1 &"
print(run(cmd))

print("Step4: 等待25秒...")
time.sleep(25)

print("Step5: 检查8070")
print(run("ss -tlnp | grep 8070"))

print("Step6: 查启动日志")
log = run("tail -25 /opt/hos_backend/app.log")
print(log)

ssh.close()
