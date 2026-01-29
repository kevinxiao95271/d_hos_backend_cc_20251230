#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""修复C0002指标项SQL"""

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

    print("修复 C0002 指标项SQL...")

    # 修复SQL
    new_sql = "select count(distinct A48,A49) AS result_value from d_mr where A14 >= 18 AND STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN #{startDate} AND #{endDate}"

    update_sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "UPDATE t_indicator_item SET query_sql = '{new_sql}' WHERE item_code = 'C0002';" """

    code, out = exec_command(client, update_sql)
    print("更新完成!")

    # 验证
    verify_sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code = 'C0002';" """
    code, out = exec_command(client, verify_sql)
    print("\n验证结果:")
    print(out)

    client.close()

except Exception as e:
    print(f"错误: {e}")
