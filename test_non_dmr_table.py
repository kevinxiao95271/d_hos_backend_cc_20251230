#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试非d_mr表的科室下钻"""

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
    print("测试：非d_mr表的科室下钻")
    print("="*80)

    # 1. 查看数据库中有哪些表
    print("\n1. 查看数据库中的表:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SHOW TABLES;" """
    code, out, err = exec_command(client, sql)
    print(out)

    # 2. 假设有一个查询其他表的SQL，测试添加B16后的效果
    print("\n2. 测试场景1: 查询不包含B16字段的表")
    print("假设SQL: SELECT COUNT(*) AS result_value FROM some_other_table WHERE ...")

    # 模拟修改后的SQL
    test_sql = "SELECT B16 as dept_code, B16 as dept_name, COUNT(*) AS result_value FROM some_other_table WHERE date_field BETWEEN '2023-01-01' AND '2023-01-31' GROUP BY B16"
    print(f"\n修改后的SQL:\n{test_sql}")
    print("\n预期结果: ❌ 报错 - Unknown column 'B16'")

    # 3. 实际测试一个不存在B16的表
    print("\n3. 实际测试（使用t_indicator表，它没有B16字段）:")
    test_sql_real = "SELECT B16 as dept_code, B16 as dept_name, COUNT(*) AS result_value FROM t_indicator GROUP BY B16"

    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{test_sql_real}" """
    code, out, err = exec_command(client, sql)

    if code != 0 or 'Unknown column' in err:
        print("✅ 符合预期: 报错了！")
        print(f"错误信息:\n{err}")
    else:
        print("结果:")
        print(out)

    # 4. 检查哪些表有B16字段
    print("\n4. 检查哪些表包含B16字段:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '{DB_NAME}' AND COLUMN_NAME = 'B16';" """
    code, out, err = exec_command(client, sql)
    print(out)

    # 5. 检查现有指标项都使用了哪些表
    print("\n5. 检查现有指标项使用的表:")
    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "SELECT DISTINCT SUBSTRING_INDEX(SUBSTRING_INDEX(query_sql, 'FROM ', -1), ' ', 1) as table_name FROM t_indicator_item WHERE query_sql IS NOT NULL LIMIT 20;" """
    code, out, err = exec_command(client, sql)
    print(out)

    client.close()

    print("\n" + "="*80)
    print("测试总结")
    print("="*80)
    print("""
如果指标项SQL查询的表不包含B16字段:
1. ❌ SQL执行会报错: Unknown column 'B16'
2. ❌ 科室下钻计算会失败
3. ⚠️  后端会抛出异常，返回500错误

建议:
- 只对包含B16字段的表进行科室下钻
- 主要数据表: d_mr (病案主表)
- 其他表如果需要科室下钻，必须包含B16字段
""")

except Exception as e:
    print(f"错误: {e}")
    import traceback
    traceback.print_exc()
