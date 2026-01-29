#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""查找测试指标-成人患者数"""

import paramiko

SERVER = "81.71.44.180"
USERNAME = "root"
PASSWORD = "Yiguo9527_"

DB_HOST = "gz-cdb-bq7gk3k5.sql.tencentcdb.com"
DB_PORT = 63606
DB_USER = "root"
DB_PASSWORD = "Yiguo9527_"
DB_NAME = "d_hos_claude_0251230"

def exec_command(client, cmd):
    stdin, stdout, stderr = client.exec_command(cmd)
    exit_code = stdout.channel.recv_exit_status()
    output = stdout.read().decode('utf-8', errors='ignore')
    return exit_code, output

try:
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)

    # 查找所有测试指标
    print("查找测试指标...")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_name LIKE '%测试%';" """
    code, out = exec_command(client, sql)
    print(out)
    print("\n")

    # 查找指标（不是指标项）
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT metric_code, metric_name, calculation_type, expression, related_items FROM t_indicator WHERE metric_name LIKE '%测试%成人%';" """
    code, out = exec_command(client, sql)
    print("测试指标配置:")
    print(out)

    client.close()

except Exception as e:
    print(f"错误: {e}")
