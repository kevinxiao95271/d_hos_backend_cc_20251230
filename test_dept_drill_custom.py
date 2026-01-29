#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试CUSTOM时间维度的科室下钻功能"""

import requests
import json

BASE_URL = "http://81.71.44.180:8080/dgear"

def test_dept_drill_custom():
    """测试科室下钻 CUSTOM 时间维度"""

    print("="*80)
    print("测试科室下钻 - CUSTOM 时间维度")
    print("="*80)

    # 测试参数
    params = {
        "metricCode": "总病案数",
        "timeDimension": "CUSTOM",
        "startDate": "2020-01-01",
        "endDate": "2020-01-11"
    }

    print(f"\n请求参数:")
    print(json.dumps(params, indent=2, ensure_ascii=False))
    print(f"\n请求URL: POST {BASE_URL}/api/indicator-result/dept-drill-down")

    try:
        response = requests.post(
            f"{BASE_URL}/api/indicator-result/dept-drill-down",
            params=params,
            timeout=60
        )

        print(f"\n响应状态码: {response.status_code}")

        if response.status_code == 200:
            result = response.json()

            if result.get('code') == 200:
                data = result.get('data', [])
                message = result.get('message', '')

                print(f"\n✅ 成功! {message}")
                print(f"✅ 返回科室数量: {len(data)}\n")

                if data:
                    print("前10个科室的结果:")
                    print("-" * 100)
                    print(f"{'科室编码':<15} {'科室名称':<25} {'时间维度':<10} {'时间值':<25} {'结果值':<10} {'状态':<10}")
                    print("-" * 100)

                    for item in data[:10]:
                        dept_code = item.get('deptCode', 'N/A')
                        dept_name = item.get('deptName', 'N/A')
                        time_dim = item.get('timeDimension', 'N/A')
                        time_value = item.get('timeValue', 'N/A')
                        result_value = item.get('resultValue', 0)
                        status = item.get('calculationStatus', 'N/A')

                        print(f"{dept_code:<15} {dept_name:<25} {time_dim:<10} {time_value:<25} {result_value:<10} {status:<10}")

                    if len(data) > 10:
                        print(f"\n... 还有 {len(data) - 10} 个科室")

                    # 验证 timeValue 格式
                    if data:
                        first_time_value = data[0].get('timeValue')
                        print(f"\n✅ timeValue 格式验证: {first_time_value}")
                        if '~' in first_time_value:
                            print("✅ 格式正确 (包含 ~ 分隔符)")
                        else:
                            print("❌ 格式错误 (缺少 ~ 分隔符)")
                else:
                    print("⚠️ 未返回任何科室数据")
                    print("可能原因:")
                    print("  1. 该指标的数据表中B16字段为空")
                    print("  2. 指定时间范围内没有数据")

            else:
                print(f"\n❌ 业务错误: {result.get('message')}")

        else:
            print(f"\n❌ HTTP错误: {response.status_code}")
            print(f"响应内容: {response.text[:500]}")

    except Exception as e:
        print(f"\n❌ 异常: {e}")
        import traceback
        traceback.print_exc()

def test_query_dept_drill_results():
    """测试查询科室下钻结果"""

    print("\n" + "="*80)
    print("测试查询已保存的科室下钻结果")
    print("="*80)

    metric_code = "总病案数"
    params = {
        "timeDimension": "CUSTOM",
        "timeValue": "2020-01-01~2020-01-11"
    }

    print(f"\n请求URL: GET {BASE_URL}/api/indicator-result/dept-drill/{metric_code}")
    print(f"查询参数:")
    print(json.dumps(params, indent=2, ensure_ascii=False))

    try:
        response = requests.get(
            f"{BASE_URL}/api/indicator-result/dept-drill/{metric_code}",
            params=params,
            timeout=30
        )

        print(f"\n响应状态码: {response.status_code}")

        if response.status_code == 200:
            result = response.json()

            if result.get('code') == 200:
                data = result.get('data', [])

                print(f"\n✅ 查询成功! 共找到 {len(data)} 条记录")

                if data:
                    print("\n前5条记录:")
                    print("-" * 100)
                    print(f"{'科室编码':<15} {'科室名称':<25} {'时间值':<25} {'结果值':<10} {'创建时间':<20}")
                    print("-" * 100)

                    for item in data[:5]:
                        dept_code = item.get('deptCode', 'N/A')
                        dept_name = item.get('deptName', 'N/A')
                        time_value = item.get('timeValue', 'N/A')
                        result_value = item.get('resultValue', 0)
                        create_time = item.get('createTime', 'N/A')

                        print(f"{dept_code:<15} {dept_name:<25} {time_value:<25} {result_value:<10} {create_time:<20}")
                else:
                    print("\n⚠️ 未找到匹配的记录")
                    print("提示: 需要先执行科室下钻计算")

            else:
                print(f"\n❌ 业务错误: {result.get('message')}")

        else:
            print(f"\n❌ HTTP错误: {response.status_code}")

    except Exception as e:
        print(f"\n❌ 异常: {e}")

if __name__ == "__main__":
    # 测试1: 执行科室下钻计算
    test_dept_drill_custom()

    # 测试2: 查询科室下钻结果
    test_query_dept_drill_results()

    print("\n" + "="*80)
    print("测试完成")
    print("="*80)
