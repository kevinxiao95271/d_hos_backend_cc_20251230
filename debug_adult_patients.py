#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""检查成人患者数指标的SQL和科室下钻问题"""

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
    print("检查成人患者数指标配置")
    print("="*80)

    # 1. 查询指标项配置
    print("\n1. 查询指标项SQL:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_name LIKE '%成人%' LIMIT 1;" """
    code, out, err = exec_command(client, sql)
    print(out)

    # 2. 查询指标配置
    print("\n2. 查询指标配置:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT metric_code, metric_name, calculation_type, expression, related_items FROM t_indicator WHERE metric_name LIKE '%成人%' LIMIT 1;" """
    code, out, err = exec_command(client, sql)
    print(out)

    # 3. 测试原始SQL（不分组）
    print("\n3. 测试原始SQL（2023-01）:")
    # 先获取SQL
    sql_query = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -N -e "SELECT query_sql FROM t_indicator_item WHERE item_name LIKE '%成人%' LIMIT 1;" """
    code, item_sql, err = exec_command(client, sql_query)

    if item_sql:
        # 替换日期参数并执行
        test_sql = item_sql.strip().replace('#{startDate}', "'2023-01-01'").replace('#{endDate}', "'2023-01-31'")
        print(f"原始SQL: {test_sql}")

        sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{test_sql}" """
        code, out, err = exec_command(client, sql)
        print(f"结果:\n{out}")

    # 4. 测试科室下钻SQL（分组）
    print("\n4. 测试科室下钻SQL（GROUP BY B16）:")
    if item_sql:
        # 修改SQL添加科室分组
        base_sql = test_sql.strip()
        if base_sql.endswith(';'):
            base_sql = base_sql[:-1]

        # 简单模拟后端的SQL修改逻辑
        import re
        select_match = re.search(r'SELECT\s+(.*?)\s+FROM', base_sql, re.IGNORECASE)
        from_match = re.search(r'FROM\s+(.+)', base_sql, re.IGNORECASE)

        if select_match and from_match:
            value_part = select_match.group(1)
            from_part = from_match.group(0)

            dept_sql = f"SELECT B16 as dept_code, B16 as dept_name, {value_part} {from_part} GROUP BY B16"
            print(f"科室下钻SQL: {dept_sql}")

            sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{dept_sql}" """
            code, out, err = exec_command(client, sql)
            print(f"结果:\n{out}")
            if err:
                print(f"错误:\n{err}")

    # 5. 检查B16字段数据
    print("\n5. 检查B16字段数据分布:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT B16, COUNT(*) as cnt FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2023-01-01' AND '2023-01-31' GROUP BY B16 ORDER BY cnt DESC LIMIT 10;" """
    code, out, err = exec_command(client, sql)
    print(out)

    client.close()

except Exception as e:
    print(f"错误: {e}")
    import traceback
    traceback.print_exc()
