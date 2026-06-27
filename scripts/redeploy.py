import paramiko, time

LOCAL_JAR  = r"d:\iCode\cursor\d_hos_backend_cc_20251230\target\indicator-management-1.0.0-SNAPSHOT.jar"
REMOTE_JAR = "/opt/hos_backend/indicator-management.jar"

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', port=22, username='root', password='Yiguo9527_', timeout=15)

def run(cmd):
    _, o, e = ssh.exec_command(cmd, timeout=30)
    return (o.read().decode('utf-8','replace') or e.read().decode('utf-8','replace')).strip()

# 取当前PID
pid_raw = run("ss -tlnp | grep 8070")
import re
m = re.search(r'pid=(\d+)', pid_raw)
pid = m.group(1) if m else None
print("当前 pid:", pid)
if pid:
    run(f"kill -9 {pid}")
    time.sleep(2)

print("上传新JAR...")
sftp = ssh.open_sftp()
sftp.put(LOCAL_JAR, REMOTE_JAR)
sftp.close()
print("上传完成")

print("启动新JAR...")
run(f"nohup java -jar {REMOTE_JAR} --server.port=8070 > /opt/hos_backend/app.log 2>&1 &")
print("等待25秒...")
time.sleep(25)

print("8070状态:", run("ss -tlnp | grep 8070"))
log = run("tail -8 /opt/hos_backend/app.log")
print("日志尾:", log)
ssh.close()
