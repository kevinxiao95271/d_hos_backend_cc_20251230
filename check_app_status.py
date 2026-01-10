#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""检查应用状态"""

import paramiko
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

SERVER = "81.71.44.180"
USERNAME = "root"
PASSWORD = "Yiguo9527_"

def exec_command(client, cmd):
    stdin, stdout, stderr = client.exec_command(cmd)
    exit_code = stdout.channel.recv_exit_status()
    output = stdout.read().decode('utf-8', errors='ignore')
    error = stderr.read().decode('utf-8', errors='ignore')
    return exit_code, output, error

try:
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)

    # 检查进程
    print("检查进程...")
    code, out, err = exec_command(client, "ps aux | grep indicator-management | grep -v grep")
    print(out if out else "应用未运行")
    print()

    # 检查日志
    print("最近的错误日志:")
    code, out, err = exec_command(client, "tail -30 /data/indicator-management/logs/error.log")
    print(out if out else "无错误")
    print()

    # 检查控制台日志
    print("启动日志（最后20行）:")
    code, out, err = exec_command(client, "tail -20 /data/indicator-management/logs/console.log")
    print(out)

    client.close()

except Exception as e:
    print(f"错误: {e}")
