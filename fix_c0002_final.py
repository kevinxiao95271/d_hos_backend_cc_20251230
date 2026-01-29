#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""修复C0002指标项SQL - 添加AS result_value"""

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
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=10)

    print("="*80)
    print("修复 C0002 - 测试指标-成人患者数 SQL")
    print("="*80)

    # 1. 查看当前SQL
    print("\n1. 当前SQL:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -N -e "SELECT query_sql FROM t_indicator_item WHERE item_code = 'C0002';" """
    code, current_sql, err = exec_command(client, sql)
    print(current_sql.strip())

    # 2. 更新SQL
    print("\n2. 更新SQL...")
    new_sql = """select count(distinct A48,A49) AS result_value from d_mr where A14 >= 18 AND STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN #{startDate} AND #{endDate}"""

    # 使用转义
    update_cmd = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} <<EOF
UPDATE t_indicator_item
SET query_sql = "{new_sql}"
WHERE item_code = 'C0002';
EOF"""

    code, out, err = exec_command(client, update_cmd)
    print("更新完成")

    # 3. 验证
    print("\n3. 验证更新后的SQL:")
    code, updated_sql, err = exec_command(client, sql)
    print(updated_sql.strip())

    # 4. 测试科室下钻
    print("\n4. 测试科室下钻计算:")
    test_cmd = f"""curl -s -X POST "http://localhost:8080/dgear/api/indicator-result/dept-drill-down?metricCode=%E6%88%90%E4%BA%BA%E6%82%A3%E8%80%85%E6%95%B0&timeDimension=MONTH&startDate=2023-01-01&endDate=2023-01-31" """
    code, result, err = exec_command(client, test_cmd)
    print(result[:500])

    client.close()
    print("\n" + "="*80)
    print("修复完成！请重新测试科室下钻功能")
    print("="*80)

except Exception as e:
    print(f"错误: {e}")
    import traceback
    traceback.print_exc()
