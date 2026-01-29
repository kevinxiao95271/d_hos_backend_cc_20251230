#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试C0002指标的科室下钻SQL"""

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
    error = stderr.read().decode('utf-8', errors='ignore')
    return exit_code, output, error

try:
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)

    print("="*80)
    print("测试 C0002 - 测试指标-成人患者数")
    print("="*80)

    # 原始SQL
    original_sql = "select count(distinct A48,A49) from d_mr where A14 >= 18 AND STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2023-01-01' AND '2023-01-31'"

    print(f"\n1. 原始SQL:")
    print(original_sql)
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{original_sql}" """
    code, out, err = exec_command(client, sql)
    print(f"结果:\n{out}")

    # 后端生成的科室下钻SQL（模拟modifySqlForDeptDrill逻辑）
    # SELECT B16 as dept_code, B16 as dept_name, count(distinct A48,A49) FROM ...
    dept_drill_sql = "SELECT B16 as dept_code, B16 as dept_name, count(distinct A48,A49) from d_mr where A14 >= 18 AND STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2023-01-01' AND '2023-01-31' GROUP BY B16"

    print(f"\n2. 科室下钻SQL（后端生成）:")
    print(dept_drill_sql)
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{dept_drill_sql}" """
    code, out, err = exec_command(client, sql)
    print(f"结果:\n{out}")
    if err and 'Warning' not in err:
        print(f"错误:\n{err}")

    # 正确的科室下钻SQL（添加AS result_value）
    correct_sql = "SELECT B16 as dept_code, B16 as dept_name, count(distinct A48,A49) AS result_value from d_mr where A14 >= 18 AND STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2023-01-01' AND '2023-01-31' GROUP BY B16"

    print(f"\n3. 正确的科室下钻SQL（添加别名）:")
    print(correct_sql)
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{correct_sql}" """
    code, out, err = exec_command(client, sql)
    print(f"结果:\n{out}")

    client.close()

except Exception as e:
    print(f"错误: {e}")
    import traceback
    traceback.print_exc()
