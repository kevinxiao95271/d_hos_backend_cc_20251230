#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试CUSTOM时间维度"""

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

    print("测试CUSTOM时间维度...")
    print()

    # 测试API
    cmd = """curl -s -X POST "http://localhost:8080/dgear/api/indicator-result/calculate?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11" """

    code, out, err = exec_command(client, cmd)
    print("API响应:")
    print(out)

    client.close()

except Exception as e:
    print(f"错误: {e}")
