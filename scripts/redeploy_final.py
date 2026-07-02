"""
部署新 JAR 到服务器，杀原进程重启
"""
import sys, os, paramiko, time
sys.stdout.reconfigure(encoding='utf-8')

LOCAL_JAR = r'd:\iCode\cursor\d_hos_backend_cc_20251230\target\indicator-management-1.0.0-SNAPSHOT.jar'
REMOTE_JAR = '/opt/hos_backend/indicator-management.jar'
REMOTE_TMP = '/opt/hos_backend/indicator-management-new.jar'

print(f'JAR 大小: {os.path.getsize(LOCAL_JAR):,} bytes')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')

# 上传
print('上传 JAR...')
sftp = ssh.open_sftp()
os.makedirs('/'.join(REMOTE_TMP.split('/')[:-1]), exist_ok=True)
sftp.put(LOCAL_JAR, REMOTE_TMP)
sftp.close()
print('上传完成')

# 杀旧进程
_, out, _ = ssh.exec_command("ps aux | grep indicator-management | grep -v grep | awk '{print $2}'")
pid = out.read().decode().strip()
if pid:
    print(f'杀掉旧进程 PID={pid}')
    ssh.exec_command(f'kill -9 {pid}')
    time.sleep(2)
else:
    print('未找到旧进程')

# 替换 JAR
ssh.exec_command(f'mv {REMOTE_TMP} {REMOTE_JAR}')
time.sleep(1)

# 启动新进程
start_cmd = (
    f'nohup java -jar {REMOTE_JAR} '
    f'--server.port=8070 '
    f'> /root/logs/indicator-backend.log 2>&1 &'
)
print(f'启动命令: {start_cmd}')
ssh.exec_command(start_cmd)

print('等待启动 (25s)...')
time.sleep(25)

# 检查进程
_, out, _ = ssh.exec_command("ps aux | grep indicator-management | grep -v grep | awk '{print $2, $11}'")
proc = out.read().decode().strip()
print(f'进程: {proc}')

# 检查端口
_, out, _ = ssh.exec_command("ss -tlnp | grep 8070")
port = out.read().decode().strip()
print(f'端口 8070: {port}')

# 检查日志最后几行
_, out, _ = ssh.exec_command("tail -30 /root/logs/indicator-backend.log 2>/dev/null")
log = out.read().decode('utf-8','replace')
print(f'启动日志:\n{log}')

ssh.close()
