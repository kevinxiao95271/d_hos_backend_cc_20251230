"""
远端部署脚本：上传新 JAR 并重启服务
"""
import paramiko
import os
import time

# ─── 连接配置（按实际修改）───
HOST     = "81.71.44.180"
PORT     = 22
USER     = "root"
PASSWORD = "Yiguo9527_"          # SSH 密码

LOCAL_JAR  = r"d:\iCode\cursor\d_hos_backend_cc_20251230\target\indicator-management-1.0.0-SNAPSHOT.jar"
REMOTE_DIR = "/opt/hos_backend"
REMOTE_JAR = f"{REMOTE_DIR}/indicator-management.jar"
LOG_FILE   = f"{REMOTE_DIR}/app.log"
APP_PORT   = 8070

def ssh_exec(client, cmd, timeout=30):
    print(f"  $ {cmd}")
    _, stdout, stderr = client.exec_command(cmd, timeout=timeout)
    out = stdout.read().decode("utf-8", errors="replace").strip()
    err = stderr.read().decode("utf-8", errors="replace").strip()
    if out: print(f"  [OUT] {out}")
    if err: print(f"  [ERR] {err}")
    return out

print("=" * 55)
print("Step 1: 连接远端服务器")
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(HOST, port=PORT, username=USER, password=PASSWORD, timeout=15)
print("  连接成功")

print("\nStep 2: 查看并杀掉占用 8070 端口的进程")
pid_out = ssh_exec(ssh, f"ss -tlnp | grep :{APP_PORT} | awk '{{print $7}}' | grep -oP 'pid=\\K[0-9]+'")
if pid_out:
    for pid in pid_out.split("\n"):
        pid = pid.strip()
        if pid:
            print(f"  杀进程 PID={pid}")
            ssh_exec(ssh, f"kill -9 {pid}")
else:
    print("  没有找到占用 8070 的进程（可能已停止）")

time.sleep(2)

print(f"\nStep 3: 确保目录存在 {REMOTE_DIR}")
ssh_exec(ssh, f"mkdir -p {REMOTE_DIR}")

print(f"\nStep 4: 备份旧 JAR（如果存在）")
ssh_exec(ssh, f"[ -f {REMOTE_JAR} ] && mv {REMOTE_JAR} {REMOTE_JAR}.bak || echo 'no old jar'")

print(f"\nStep 5: 上传新 JAR（{os.path.getsize(LOCAL_JAR)/1024/1024:.1f} MB，请稍候...）")
sftp = ssh.open_sftp()
sftp.put(LOCAL_JAR, REMOTE_JAR)
sftp.close()
print("  上传完成")

print(f"\nStep 6: 启动新服务（后台运行，日志写入 {LOG_FILE}）")
start_cmd = (
    f"nohup java -jar {REMOTE_JAR} "
    f"--server.port={APP_PORT} "
    f"> {LOG_FILE} 2>&1 &"
)
ssh_exec(ssh, start_cmd)

print("\nStep 7: 等待 15 秒让服务启动...")
time.sleep(15)

print("\nStep 8: 检查服务是否已监听 8070")
check = ssh_exec(ssh, f"ss -tlnp | grep :{APP_PORT}")
if str(APP_PORT) in check:
    print("  ✅ 服务已成功启动！")
else:
    print("  ⚠️  端口未监听，查看启动日志末尾：")
    ssh_exec(ssh, f"tail -40 {LOG_FILE}")

ssh.close()
print("\n部署完成。")
