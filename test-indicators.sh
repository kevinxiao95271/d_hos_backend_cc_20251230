#!/bin/bash
# 指标计算API测试脚本 - 2023年度数据

BASE_URL="http://localhost:8080/dgear/api/indicator-result/calculate"
YEAR="2023"
START_DATE="2023-01-01"
END_DATE="2023-12-31"

echo "========================================="
echo "医疗指标计算API测试 - ${YEAR}年度"
echo "========================================="
echo ""

# 测试函数
test_indicator() {
    local indicator_name=$1
    local indicator_name_cn=$2

    echo "【测试】${indicator_name_cn}"

    # URL编码中文指标名称
    local encoded_name=$(echo -n "$indicator_name" | jq -sRr @uri)

    # 调用API
    response=$(curl -s -X POST "${BASE_URL}?metricCode=${encoded_name}&timeDimension=YEAR&startDate=${START_DATE}&endDate=${END_DATE}")

    # 解析结果
    code=$(echo "$response" | jq -r '.code')
    message=$(echo "$response" | jq -r '.message')

    if [ "$code" == "200" ]; then
        result_value=$(echo "$response" | jq -r '.data.resultValue')
        status=$(echo "$response" | jq -r '.data.calculationStatus')
        echo "  ✅ 成功: ${message}"
        echo "  📊 结果: ${result_value}"
        echo "  📌 状态: ${status}"
    else
        echo "  ❌ 失败: ${message}"
    fi
    echo ""
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. 手术相关指标测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
test_indicator "手术患者并发症发生率" "手术患者并发症发生率"
test_indicator "I类切口手术部位感染率" "I类切口手术部位感染率"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. 急性心肌梗死指标测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
test_indicator "急性心肌梗死病种例数" "急性心肌梗死病种例数"
test_indicator "急性心肌梗死平均住院日" "急性心肌梗死平均住院日"
test_indicator "急性心肌梗死次均费用" "急性心肌梗死次均费用"
test_indicator "急性心肌梗死病死率" "急性心肌梗死病死率"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. 心力衰竭指标测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
test_indicator "心力衰竭病种例数" "心力衰竭病种例数"
test_indicator "心力衰竭平均住院日" "心力衰竭平均住院日"
test_indicator "心力衰竭次均费用" "心力衰竭次均费用"
test_indicator "心力衰竭病死率" "心力衰竭病死率"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. 肺炎（住院、成人）指标测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
test_indicator "肺炎（住院、成人）病种例数" "肺炎（住院、成人）病种例数"
test_indicator "肺炎（住院、成人）平均住院日" "肺炎（住院、成人）平均住院日"
test_indicator "肺炎（住院、成人）次均费用" "肺炎（住院、成人）次均费用"
test_indicator "肺炎（住院、成人）病死率" "肺炎（住院、成人）病死率"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "测试完成"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
