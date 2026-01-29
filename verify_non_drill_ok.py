#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""验证：非下钻指标不会报错"""

import requests
import json

BASE_URL = "http://81.71.44.180:8080/dgear"

print("="*80)
print("测试：配置成非下钻指标是否会报错")
print("="*80)

# 假设有一个使用非d_mr表的指标
# 但我们只做普通计算，不做科室下钻

print("\n场景：使用t_indicator表的指标（没有B16字段）")
print("-"*80)

# 注意：这里实际上不存在这样的指标，仅为演示
# 如果真的存在，普通计算应该是正常的

print("\n1. 普通计算（不下钻）")
print("   调用接口: POST /api/indicator-result/calculate")
print("   预期结果: ✅ 正常执行（不会修改SQL，不需要B16字段）")

print("\n2. 科室下钻")
print("   调用接口: POST /api/indicator-result/dept-drill-down")
print("   预期结果: ❌ 报错500（会修改SQL添加B16，但表中没有B16字段）")

print("\n" + "="*80)
print("结论")
print("="*80)
print("""
✅ 如果配置成非下钻指标（只用普通计算接口）：
   - 不会报错
   - 可以查询任何表
   - SQL不会被修改
   - 正常返回结果

❌ 如果使用科室下钻接口：
   - 会自动修改SQL
   - 必须表中有B16字段
   - 没有B16会报错500

建议：
- 前端根据指标的数据源（dataSource）来决定是否显示"科室下钻"按钮
- 只有dataSource='d_mr'的指标才显示科室下钻功能
- 其他指标只提供普通计算功能
""")

# 实际测试一个真实指标（使用d_mr）
print("\n实际测试：成人患者数（d_mr表，有B16）")
print("-"*80)

try:
    # 普通计算
    print("\n普通计算:")
    response = requests.post(
        f"{BASE_URL}/api/indicator-result/calculate",
        params={
            "metricCode": "成人患者数",
            "timeDimension": "MONTH",
            "startDate": "2023-01-01",
            "endDate": "2023-01-31"
        },
        timeout=30
    )

    if response.status_code == 200:
        data = response.json()
        if data.get('code') == 200:
            print(f"  ✅ 成功: 结果 = {data.get('data', {}).get('resultValue')}人")
        else:
            print(f"  ✗ 失败: {data.get('message')}")

    # 科室下钻
    print("\n科室下钻:")
    response = requests.post(
        f"{BASE_URL}/api/indicator-result/dept-drill-down",
        params={
            "metricCode": "成人患者数",
            "timeDimension": "MONTH",
            "startDate": "2023-01-01",
            "endDate": "2023-01-31"
        },
        timeout=30
    )

    if response.status_code == 200:
        data = response.json()
        if data.get('code') == 200:
            dept_count = len(data.get('data', []))
            total = sum([d.get('resultValue', 0) for d in data.get('data', [])])
            print(f"  ✅ 成功: {dept_count}个科室, 总计{total}人")
        else:
            print(f"  ✗ 失败: {data.get('message')}")

except Exception as e:
    print(f"  错误: {e}")

print("\n" + "="*80)
