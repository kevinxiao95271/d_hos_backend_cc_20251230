#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
指标科室下钻接口调用示例
真实可运行的完整示例
"""

import requests
import json
from datetime import datetime

# 服务器配置
BASE_URL = "http://81.71.44.180:8080/dgear"

def print_section(title):
    """打印章节标题"""
    print("\n" + "="*80)
    print(f"  {title}")
    print("="*80 + "\n")

def test_dept_drill():
    """测试科室下钻功能"""

    print_section("指标科室下钻完整示例")

    # ========================================
    # 示例1: 使用真实指标进行科室下钻
    # ========================================

    print_section("示例1: 单指标项科室下钻（calculationType=ITEM）")

    # 指标信息（从数据库中真实存在的）
    print("指标信息:")
    print("  指标编码: 剖宫产率")
    print("  指标名称: 剖宫产率")
    print("  计算类型: ITEM (单指标项)")
    print("  关联指标项: [\"a0032\"]")
    print("  说明: 这是一个单指标项，不涉及表达式计算")

    # 构建请求
    request_data = {
        "metricCode": "剖宫产率",
        "timeDimension": "year",
        "startDate": "2020-01-01",
        "endDate": "2020-12-31"
    }

    print(f"\n请求接口: POST {BASE_URL}/api/indicator-result/dept-drill-down")
    print(f"请求参数:")
    print(json.dumps(request_data, indent=2, ensure_ascii=False))

    # 发送请求
    print("\n发送请求...")
    try:
        response = requests.post(
            f"{BASE_URL}/api/indicator-result/dept-drill-down",
            params=request_data,  # 使用params而不是json
            timeout=60
        )

        print(f"响应状态码: {response.status_code}")

        if response.status_code == 200:
            result = response.json()

            if result.get('code') == 200:
                data = result.get('data', [])
                print(f"\n✅ 成功! 共返回 {len(data)} 个科室的数据\n")

                # 显示前5个科室的结果
                print("前5个科室的下钻结果:")
                print("-" * 80)
                print(f"{'科室编码':<15} {'科室名称':<20} {'结果值':<15} {'状态':<10}")
                print("-" * 80)

                for item in data[:5]:
                    dept_code = item.get('deptCode', 'N/A')
                    dept_name = item.get('deptName', 'N/A')
                    result_value = item.get('resultValue', 0)
                    status = item.get('calculationStatus', 'N/A')
                    print(f"{dept_code:<15} {dept_name:<20} {result_value:<15} {status:<10}")

                if len(data) > 5:
                    print(f"... 还有 {len(data) - 5} 个科室")

                # 显示完整的第一条记录
                if data:
                    print("\n第一条完整记录:")
                    print(json.dumps(data[0], indent=2, ensure_ascii=False))

            else:
                print(f"❌ 业务错误: {result.get('message')}")
        else:
            print(f"❌ HTTP错误: {response.text}")

    except Exception as e:
        print(f"❌ 请求异常: {e}")

    # ========================================
    # 示例2: 使用表达式指标进行科室下钻
    # ========================================

    print_section("示例2: 表达式指标科室下钻（calculationType=EXPRESSION）")

    print("指标信息:")
    print("  指标编码: 单病种质量控制指标-急性心肌梗死患者住院病死率")
    print("  指标名称: 单病种质量控制指标-急性心肌梗死患者住院病死率")
    print("  计算类型: EXPRESSION (表达式计算)")
    print("  表达式: a0027/a0329")
    print("  关联指标项: [\"a0027\", \"a0329\"]")
    print("  说明: 这是一个比率指标，需要表达式计算")

    request_data = {
        "metricCode": "单病种质量控制指标-急性心肌梗死患者住院病死率",
        "timeDimension": "year",
        "startDate": "2020-01-01",
        "endDate": "2020-12-31"
    }

    print(f"\n请求接口: POST {BASE_URL}/api/indicator-result/dept-drill-down")
    print(f"请求参数:")
    print(json.dumps(request_data, indent=2, ensure_ascii=False))

    print("\n发送请求...")
    try:
        response = requests.post(
            f"{BASE_URL}/api/indicator-result/dept-drill-down",
            params=request_data,  # 使用params而不是json
            timeout=60
        )

        if response.status_code == 200:
            result = response.json()

            if result.get('code') == 200:
                data = result.get('data', [])
                print(f"\n✅ 成功! 共返回 {len(data)} 个科室的数据")

                if data:
                    print(f"\n前3个科室的结果:")
                    for item in data[:3]:
                        print(f"  科室: {item.get('deptName')} | 结果值: {item.get('resultValue')} | 状态: {item.get('calculationStatus')}")
            else:
                print(f"❌ 业务错误: {result.get('message')}")
        else:
            print(f"❌ HTTP错误")

    except Exception as e:
        print(f"❌ 请求异常: {e}")

    # ========================================
    # 示例3: 查询已保存的科室下钻结果
    # ========================================

    print_section("示例3: 查询已保存的科室下钻结果")

    print("查询参数:")
    params = {
        "metricCode": "剖宫产率",
        "timeDimension": "year",
        "timeValue": "2020"
    }
    print(json.dumps(params, indent=2, ensure_ascii=False))

    print(f"\n请求接口: GET {BASE_URL}/api/indicator-result/dept-drill/{{metricCode}}")
    print("说明: 查询之前计算过的科室下钻结果（从数据库读取）\n")

    try:
        metric_code = params["metricCode"]
        query_params = {
            "timeDimension": params.get("timeDimension"),
            "timeValue": params.get("timeValue")
        }

        response = requests.get(
            f"{BASE_URL}/api/indicator-result/dept-drill/{metric_code}",
            params=query_params,
            timeout=30
        )

        if response.status_code == 200:
            result = response.json()

            if result.get('code') == 200:
                data = result.get('data', [])
                print(f"✅ 查询成功! 共找到 {len(data)} 条历史记录")

                if data:
                    print(f"\n前3条记录:")
                    for item in data[:3]:
                        create_time = item.get('createTime', 'N/A')
                        dept_name = item.get('deptName', 'N/A')
                        result_value = item.get('resultValue', 0)
                        print(f"  {create_time} | 科室: {dept_name} | 结果值: {result_value}")
            else:
                print(f"查询结果为空或出错: {result.get('message')}")
        else:
            print(f"❌ HTTP错误")

    except Exception as e:
        print(f"❌ 请求异常: {e}")

    # ========================================
    # curl 命令示例
    # ========================================

    print_section("等效的 curl 命令")

    print("示例1 - 执行科室下钻计算:")
    print('''
curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/dept-drill-down?metricCode=%E5%89%96%E5%AE%AB%E4%BA%A7%E7%8E%87&timeDimension=year&startDate=2020-01-01&endDate=2020-12-31"
''')

    print("\n示例2 - 查询科室下钻结果:")
    print('''
curl -X GET "http://81.71.44.180:8080/dgear/api/indicator-result/dept-drill/%E5%89%96%E5%AE%AB%E4%BA%A7%E7%8E%87?timeDimension=year&timeValue=2020"
''')

    # ========================================
    # 常见问题说明
    # ========================================

    print_section("常见问题说明")

    print("""
1. 为什么没有返回科室下钻数据？
   - 确认调用的是 /api/indicator-result/dept-drill-down 接口
   - 确认使用URL参数(params)而不是JSON body
   - 检查指标项的 SQL 中是否包含 B16 字段
   - 确认数据库表中的 B16 字段有有效值（非空）
   - 查看日志: tail -f /data/indicator-management/logs/error.log

2. 单指标项（ITEM类型）能否下钻？
   - 可以！只要指标项的 SQL 能查询到 B16 字段即可
   - 与是否有表达式计算无关

3. 结果保存在哪里？
   - 科室下钻结果保存在: t_indicator_result_dept 表
   - 普通计算结果保存在: t_indicator_result 表

4. 如何查看 SQL 执行情况？
   - tail -f /data/indicator-management/logs/sql.log
   - 查找包含 "GROUP BY B16" 的 SQL

5. 时间维度参数说明:
   - year: 按年统计
   - quarter: 按季度统计
   - month: 按月统计
   - 日期范围必须与时间维度匹配
""")

    print_section("测试完成")

if __name__ == "__main__":
    test_dept_drill()
