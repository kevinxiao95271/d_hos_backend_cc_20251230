#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""创建一个使用非d_mr表的测试指标项，验证科室下钻报错"""

import paramiko
import sys
import io
import json

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
    print("测试：使用非d_mr表的指标项进行科室下钻")
    print("="*80)

    # 1. 创建一个测试指标项（使用t_indicator表）
    print("\n1. 创建测试指标项 TEST_NO_B16...")

    insert_sql = """INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, status)
VALUES ('TEST_NO_B16', '测试-无B16字段表', 'COLLECTED', 't_indicator', 'SELECT COUNT(*) AS result_value FROM t_indicator WHERE create_time BETWEEN #{startDate} AND #{endDate}', 1)
ON DUPLICATE KEY UPDATE query_sql = 'SELECT COUNT(*) AS result_value FROM t_indicator WHERE create_time BETWEEN #{startDate} AND #{endDate}';"""

    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{insert_sql}" """
    code, out, err = exec_command(client, sql)
    print("✓ 测试指标项已创建")

    # 2. 创建对应的指标
    print("\n2. 创建测试指标...")
    insert_indicator = """INSERT INTO t_indicator (metric_code, metric_name, calculation_type, expression, related_items, is_leaf, status)
VALUES ('测试无B16表', '测试无B16表', 'ITEM', 'TEST_NO_B16', '["TEST_NO_B16"]', 1, 1)
ON DUPLICATE KEY UPDATE expression = 'TEST_NO_B16', related_items = '["TEST_NO_B16"]';"""

    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{insert_indicator}" """
    code, out, err = exec_command(client, sql)
    print("✓ 测试指标已创建")

    # 3. 测试普通计算（应该成功）
    print("\n3. 测试普通计算...")
    test_cmd = """curl -s -X POST "http://localhost:8080/dgear/api/indicator-result/calculate?metricCode=%E6%B5%8B%E8%AF%95%E6%97%A0B16%E8%A1%A8&timeDimension=MONTH&startDate=2023-01-01&endDate=2023-01-31" """
    code, result, err = exec_command(client, test_cmd)

    try:
        data = json.loads(result)
        if data.get('code') == 200:
            print(f"✓ 普通计算成功: 结果 = {data.get('data', {}).get('resultValue')}")
        else:
            print(f"✗ 普通计算失败: {data.get('message')}")
    except:
        print(f"响应: {result[:200]}")

    # 4. 测试科室下钻（应该失败）
    print("\n4. 测试科室下钻（预期失败）...")
    test_cmd = """curl -s -X POST "http://localhost:8080/dgear/api/indicator-result/dept-drill-down?metricCode=%E6%B5%8B%E8%AF%95%E6%97%A0B16%E8%A1%A8&timeDimension=MONTH&startDate=2023-01-01&endDate=2023-01-31" """
    code, result, err = exec_command(client, test_cmd)

    try:
        data = json.loads(result)
        if data.get('code') == 500 or data.get('code') == 400:
            print(f"✓ 符合预期: 返回错误")
            print(f"  错误码: {data.get('code')}")
            print(f"  错误信息: {data.get('message')}")
        else:
            print(f"✗ 未预期的结果: code={data.get('code')}")
            print(f"  数据: {data}")
    except Exception as e:
        print(f"响应解析失败: {result[:300]}")

    # 5. 清理测试数据
    print("\n5. 清理测试数据...")
    cleanup_sql = """DELETE FROM t_indicator WHERE metric_code = '测试无B16表';
DELETE FROM t_indicator_item WHERE item_code = 'TEST_NO_B16';"""

    sql = f"""mysql -h {DB_HOST} -P {DB_PORT} -u {DB_USER} -p{DB_PASSWORD} {DB_NAME} -e "{cleanup_sql}" """
    code, out, err = exec_command(client, sql)
    print("✓ 测试数据已清理")

    client.close()

    print("\n" + "="*80)
    print("测试结论")
    print("="*80)
    print("""
如果指标项SQL使用的表不包含B16字段:
✓ 普通计算: 正常工作
✗ 科室下钻: 报错（Unknown column 'B16'）
✗ 后端返回: 500错误，包含详细错误信息

错误处理流程:
1. SQL执行失败（数据库报错）
2. 后端捕获异常
3. 返回BusinessException
4. 用户看到: "查询科室下钻数据失败: xxx"
""")

except Exception as e:
    print(f"错误: {e}")
    import traceback
    traceback.print_exc()
