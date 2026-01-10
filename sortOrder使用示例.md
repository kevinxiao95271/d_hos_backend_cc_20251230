# sortOrder 排序字段使用示例

## 示例1：创建有序的三级指标树

```javascript
// 步骤1：创建顶级分类（sortOrder控制顶级分类的顺序）
await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '医疗质量控制指标',
    metricName: '医疗质量控制指标',
    parentCode: null,
    indicatorLevel: 1,
    isLeaf: 0,
    metricType: 'QUANTITATIVE',
    calculationType: 'NONE',
    status: 1,
    sortOrder: 1  // ← 第一个顶级分类
  })
});

await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '患者安全指标',
    metricName: '患者安全指标',
    parentCode: null,
    indicatorLevel: 1,
    isLeaf: 0,
    metricType: 'QUANTITATIVE',
    calculationType: 'NONE',
    status: 1,
    sortOrder: 2  // ← 第二个顶级分类
  })
});

// 步骤2：在"医疗质量控制指标"下创建二级分类（sortOrder在同一父节点下排序）
await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '重点病种质量控制指标',
    metricName: '重点病种质量控制指标',
    parentCode: '医疗质量控制指标',  // ← 父节点
    indicatorLevel: 2,
    isLeaf: 0,
    metricType: 'QUANTITATIVE',
    calculationType: 'NONE',
    status: 1,
    sortOrder: 1  // ← 在"医疗质量控制指标"下排第一
  })
});

await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '手术质量控制指标',
    metricName: '手术质量控制指标',
    parentCode: '医疗质量控制指标',  // ← 同一父节点
    indicatorLevel: 2,
    isLeaf: 0,
    metricType: 'QUANTITATIVE',
    calculationType: 'NONE',
    status: 1,
    sortOrder: 2  // ← 在"医疗质量控制指标"下排第二
  })
});

// 步骤3：在"重点病种质量控制指标"下创建叶子节点（sortOrder控制叶子节点顺序）
await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '急性心肌梗死平均住院日',
    metricName: '急性心肌梗死平均住院日',
    parentCode: '重点病种质量控制指标',  // ← 父节点
    indicatorLevel: 3,
    isLeaf: 1,
    metricType: 'QUANTITATIVE',
    calculationType: 'EXPRESSION',
    expression: 'a0034/a0032',
    relatedItems: '["a0034","a0032"]',
    unit: '天',
    supportDeptDrill: 1,
    status: 1,
    sortOrder: 1  // ← 在"重点病种质量控制指标"下排第一
  })
});

await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '心力衰竭平均住院日',
    metricName: '心力衰竭平均住院日',
    parentCode: '重点病种质量控制指标',  // ← 同一父节点
    indicatorLevel: 3,
    isLeaf: 1,
    metricType: 'QUANTITATIVE',
    calculationType: 'EXPRESSION',
    expression: 'a0052/a0050',
    relatedItems: '["a0052","a0050"]',
    unit: '天',
    supportDeptDrill: 1,
    status: 1,
    sortOrder: 2  // ← 在"重点病种质量控制指标"下排第二
  })
});
```

**查询树形结构后的显示效果：**

```
医疗质量控制指标 (sortOrder: 1)
├── 重点病种质量控制指标 (sortOrder: 1)
│   ├── 急性心肌梗死平均住院日 (sortOrder: 1)
│   └── 心力衰竭平均住院日 (sortOrder: 2)
└── 手术质量控制指标 (sortOrder: 2)

患者安全指标 (sortOrder: 2)
```

---

## 示例2：预留间隔便于后期插入

```javascript
// 初始创建时预留间隔
await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '指标A',
    metricName: '指标A',
    parentCode: '某分类',
    indicatorLevel: 2,
    isLeaf: 1,
    metricType: 'QUANTITATIVE',
    calculationType: 'ITEM',
    relatedItems: '["a0001"]',
    status: 1,
    sortOrder: 10  // ← 预留空间
  })
});

await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '指标B',
    metricName: '指标B',
    parentCode: '某分类',
    indicatorLevel: 2,
    isLeaf: 1,
    metricType: 'QUANTITATIVE',
    calculationType: 'ITEM',
    relatedItems: '["a0002"]',
    status: 1,
    sortOrder: 20  // ← 间隔10
  })
});

// 后期需要在指标A和指标B之间插入新指标
await fetch('http://localhost:8080/dgear/api/indicator', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    metricCode: '指标A2',
    metricName: '指标A2（新增）',
    parentCode: '某分类',
    indicatorLevel: 2,
    isLeaf: 1,
    metricType: 'QUANTITATIVE',
    calculationType: 'ITEM',
    relatedItems: '["a0003"]',
    status: 1,
    sortOrder: 15  // ← 插入到中间，系统自动排序
  })
});
```

**最终显示顺序：**
```
某分类
├── 指标A (sortOrder: 10)
├── 指标A2（新增）(sortOrder: 15)  ← 自动排到中间
└── 指标B (sortOrder: 20)
```

---

## 示例3：修改已有节点的排序

```javascript
// 假设原来的顺序是：指标A(1) → 指标B(2) → 指标C(3)
// 现在想把指标C调到第一位

// 查询指标C的详情
const response = await fetch('http://localhost:8080/dgear/api/indicator/code/指标C');
const result = await response.json();
const indicatorC = result.data;

// 更新sortOrder为0（比原来的1还小）
await fetch(`http://localhost:8080/dgear/api/indicator/${indicatorC.id}`, {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    ...indicatorC,
    sortOrder: 0  // ← 改成0，就会排到最前面
  })
});
```

**修改后的顺序：**
```
某分类
├── 指标C (sortOrder: 0)  ← 现在排第一
├── 指标A (sortOrder: 1)
└── 指标B (sortOrder: 2)
```

---

## 示例4：批量调整排序

```javascript
// 场景：有5个指标需要重新排序
const indicators = [
  { id: 101, newOrder: 5 },
  { id: 102, newOrder: 4 },
  { id: 103, newOrder: 3 },
  { id: 104, newOrder: 2 },
  { id: 105, newOrder: 1 }
];

// 批量更新
for (const item of indicators) {
  // 先查询原数据
  const response = await fetch(`http://localhost:8080/dgear/api/indicator/${item.id}`);
  const result = await response.json();
  const indicator = result.data;

  // 更新sortOrder
  await fetch(`http://localhost:8080/dgear/api/indicator/${item.id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      ...indicator,
      sortOrder: item.newOrder
    })
  });
}
```

---

## 关键要点总结

### ✅ DO（推荐做法）
1. **同级节点从1开始递增**：简单直观
2. **预留间隔**：每个节点间隔5或10，便于后期插入
3. **一致性**：同一层级使用相同的间隔规则
4. **按业务重要性**：核心指标用小数字，次要指标用大数字

### ❌ DON'T（避免的做法）
1. **不要跨父节点比较**：不同父节点下的sortOrder没有可比性
2. **不要留太大间隔**：如间隔100，浪费数值空间
3. **不要使用负数**：虽然可以，但不直观
4. **不要忘记同步更新**：调整顺序后要考虑相邻节点

---

## 前端展示效果

后端查询 `/api/indicator/tree` 接口时，已经按 `sortOrder` 排序：

```java
// IndicatorController.java - Line 60
queryWrapper.orderByAsc(Indicator::getSortOrder);
```

前端直接使用返回的数据即可，无需额外排序：

```vue
<template>
  <el-tree :data="treeData" node-key="id">
    <!-- 数据已按sortOrder排序，直接渲染即可 -->
  </el-tree>
</template>

<script setup>
const loadTree = async () => {
  const response = await fetch('http://localhost:8080/dgear/api/indicator/tree');
  const result = await response.json();
  treeData.value = result.data;  // 已排序
};
</script>
```

---

**文档版本**: 1.0
**创建时间**: 2026-01-09
