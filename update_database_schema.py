#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
修改数据库字段长度以支持CUSTOM时间维度
"""

import paramiko
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

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
    error = stderr.read().decode('utf-8', errors='ignore')
    return exit_code, output, error

try:
    print("连接服务器...")
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)
    print("✓ 连接成功\n")

    # 1. 检查当前字段长度
    print("检查当前字段定义...")
    sql = f"mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e \"SHOW COLUMNS FROM t_indicator_result LIKE 'time_value';\""
    code, out, err = exec_command(client, sql)
    print(out)

    # 2. 修改 t_indicator_result 表
    print("\n修改 t_indicator_result 表...")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "ALTER TABLE t_indicator_result MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';" """
    code, out, err = exec_command(client, sql)
    if code == 0:
        print("✓ t_indicator_result 修改成功")
    else:
        print(f"✗ 修改失败: {err}")

    # 3. 修改 t_indicator_result_dept 表
    print("\n修改 t_indicator_result_dept 表...")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "ALTER TABLE t_indicator_result_dept MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';" """
    code, out, err = exec_command(client, sql)
    if code == 0:
        print("✓ t_indicator_result_dept 修改成功")
    else:
        print(f"✗ 修改失败: {err}")

    # 4. 验证修改
    print("\n验证修改...")
    sql = f"mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e \"SHOW COLUMNS FROM t_indicator_result LIKE 'time_value';\""
    code, out, err = exec_command(client, sql)
    print(out)

    sql = f"mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e \"SHOW COLUMNS FROM t_indicator_result_dept LIKE 'time_value';\""
    code, out, err = exec_command(client, sql)
    print(out)

    client.close()
    print("\n✅ 数据库字段修改完成！")
    print("\n现在可以测试 CUSTOM 时间维度功能了：")
    print('curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/calculate?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11"')

except Exception as e:
    print(f"错误: {e}")
    sys.exit(1)
