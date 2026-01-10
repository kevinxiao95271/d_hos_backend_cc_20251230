#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""远程重启服务脚本"""

import paramiko
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

SERVER = "81.71.44.180"
USERNAME = "root"
PASSWORD = "Yiguo9527_"
DEPLOY_PATH = "/data/indicator-management"

def exec_command(client, cmd):
    """执行命令并返回输出"""
    stdin, stdout, stderr = client.exec_command(cmd)
    exit_code = stdout.channel.recv_exit_status()
    output = stdout.read().decode('utf-8', errors='ignore')
    error = stderr.read().decode('utf-8', errors='ignore')
    return exit_code, output, error

try:
    print("连接服务器...")
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)
    print("✓ 连接成功\n")

    # 修复脚本换行符
    print("修复脚本...")
    code, out, err = exec_command(client, f"cd {DEPLOY_PATH} && sed -i 's/\\r$//' *.sh && chmod +x *.sh")
    print(f"✓ 脚本修复完成\n")

    # 停止旧应用
    print("停止旧应用...")
    code, out, err = exec_command(client, f"cd {DEPLOY_PATH} && ./stop.sh")
    print(out if out else "无运行中的应用")

    # 启动新应用
    print("\n启动新应用...")
    code, out, err = exec_command(client, f"cd {DEPLOY_PATH} && ./start.sh")
    print(out)
    if err:
        print(f"错误: {err}")

    # 等待启动
    import time
    time.sleep(5)

    # 检查日志
    print("\n检查应用日志...")
    code, out, err = exec_command(client, f"tail -30 {DEPLOY_PATH}/logs/console.log")
    print(out)

    # 检查进程
    print("\n检查进程...")
    code, out, err = exec_command(client, f"ps aux | grep indicator-management | grep -v grep")
    if out:
        print(f"✓ 应用已启动:")
        print(out)
    else:
        print("✗ 应用未启动")

    client.close()
    print("\n部署完成！")

except Exception as e:
    print(f"错误: {e}")
    sys.exit(1)
