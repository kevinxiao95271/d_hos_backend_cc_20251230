# 评审指标系统 - 交付物清单

**生成日期**: 2026-04-19  
**项目**: 评审指标系统最小粒子层实施方案

---

## 📦 交付物文件夹结构

```
evaluation_indicator_deliverables/
├── README.md (本文件)
├── 核心文档 (DOCX格式)
│   ├── 1_评审指标系统设计分析报告.docx (25KB)
│   ├── 2_评审指标系统实施指南.docx (20KB)
│   └── 3_评审指标系统成果总结.docx (22KB)
│
├── 核心SQL脚本 (可直接执行)
│   ├── 0_schema_particle_layer.sql (粒子层表结构)
│   ├── 1_load_particles.sql (粒子装载存储过程)
│   └── 2_agg_rules_init.sql (聚合规则初始化数据)
│
├── 参考资料 (从容器镜像提取)
│   ├── container_quality_assessment_sql/ (质量评估SQL)
│   │   ├── quality_assessment_tables.sql
│   │   ├── quality_assessment_procedures.sql
│   │   ├── quality_assessment_reg_microService.sql
│   │   └── index.json
│   │
│   └── container_indicator_sql/ (1377个指标SQL文件)
│       ├── 1.4.5_（五）开放床位使用率.sql
│       ├── 1.4.6_（六）核定床位使用率.sql
│       ├── 1.4.7.1_出院患者平均住院日.sql
│       ├── 2.1.1_（一）收治病种数量.sql
│       ├── ... (包含全量指标定义)
│       └── update_source_kpi_id.sql
```

---

## 📄 核心文档说明

### 文档1: 评审指标系统设计分析报告
**用途**: 深度架构分析和设计决策说明  
**内容**:
- 现有 KPI 系统架构分析
- 评审指标最小粒子模型（3类核心粒子）
- 统一中间表 t_mid_detail 设计
- 聚合层架构设计
- SQL 计算链路升级
- 后续扩展方向

**适用人群**: 架构师、高级开发

### 文档2: 评审指标系统实施指南
**用途**: 快速开始和实施路线图  
**内容**:
- 最小可用样本的快速开始（5步）
- 三份文档的具体补充方案
- 表结构关键设计决策
- 实施路线图（4个Phase）
- 常见问题解答
- 维护和扩展指南

**适用人群**: 项目经理、实施工程师、DBA

### 文档3: 评审指标系统成果总结
**用途**: 成果清单和验证步骤  
**内容**:
- 三份文档状态和补充方案
- 四张核心表结构详解
- 架构变革对比
- 快速验证步骤
- 后续Phase工作安排

**适用人群**: 项目管理、过程验收

---

## 💾 SQL脚本使用指南

### 脚本1: schema_particle_layer.sql (400+行)
**功能**: 创建粒子层和聚合层所有表结构  
**包含表**:
- t_mid_detail - 统一粒子中间表
- t_particle_rule - 粒子定义
- t_agg_rule - 聚合规则
- t_item_particle_mapping - 指标项映射
- t_particle_load_task - 装载任务日志
- t_item_agg_task - 聚合任务日志

**执行**:
```bash
mysql -u root -p database_name < 0_schema_particle_layer.sql
```

### 脚本2: load_particles.sql (300+行)
**功能**: 定义粒子装载存储过程  
**包含过程**:
- sp_load_particle_case_settlement() - 病例粒子装载
- sp_load_particle_case_diag() - 诊断粒子装载
- sp_load_particle_case_op() - 手术粒子装载
- sp_load_all_particles() - 批量装载

**执行**:
```bash
mysql -u root -p database_name < 1_load_particles.sql

# 装载测试数据
mysql -u root -p database_name -e "CALL sp_load_all_particles('2025-01-01', '2025-01-31');"
```

### 脚本3: agg_rules_init.sql (250+行)
**功能**: 初始化聚合规则和指标映射  
**包含内容**:
- 6种聚合规则 (COUNT/SUM/AVG/DISTINCT_COUNT等)
- 7个代表性指标映射 (肺炎、费用、死亡等)
- sp_generate_item_agg_sql() - 动态SQL生成存储过程
- sp_execute_item_aggregation() - 聚合执行存储过程

**执行**:
```bash
mysql -u root -p database_name < 2_agg_rules_init.sql

# 验证规则已初始化
mysql -u root -p database_name -e "SELECT * FROM t_agg_rule;"
```

---

## 📚 参考资料说明

### container_quality_assessment_sql/ (质量评估参考)
**来源**: 从 urm-v8 容器镜像提取  
**包含文件**:
- quality_assessment_tables.sql - 质量评估表结构定义
- quality_assessment_procedures.sql - 质量评估存储过程
- quality_assessment_reg_microService.sql - 微服务注册配置
- index.json - 配置索引

**用途**: 参考如何设计医疗质量评估表和存储过程

### container_indicator_sql/ (全量指标SQL参考)
**来源**: 从 urm-v8 容器镜像提取  
**包含文件**: 1377个指标SQL文件  
**文件范围**:
- 第1章: 1.3.4 - 1.4.7 (资源配置、运行效率)
- 第2章: 2.1 - 2.2 (医疗能力、核心制度)
- 第3章: 3.1 - 3.3 (医疗质量、质控指标)
- 第4章: 4.* (单病种质控，全55个病种)
- 第5章: 5.* (重点技术，全18个技术)

**用途**: 参考现有指标实现、学习SQL模式、验证粒子设计

---

## 🚀 快速开始（5步）

### 步骤1: 准备数据库
```bash
# 创建数据库（如未存在）
mysql -u root -p -e "CREATE DATABASE d_hos_claude_0251230 DEFAULT CHARSET utf8mb4;"
```

### 步骤2: 创建表结构
```bash
cd evaluation_indicator_deliverables
mysql -u root -p d_hos_claude_0251230 < 0_schema_particle_layer.sql
```

### 步骤3: 创建存储过程
```bash
mysql -u root -p d_hos_claude_0251230 < 1_load_particles.sql
```

### 步骤4: 初始化聚合规则
```bash
mysql -u root -p d_hos_claude_0251230 < 2_agg_rules_init.sql
```

### 步骤5: 装载测试数据
```bash
mysql -u root -p d_hos_claude_0251230 -e \
  "CALL sp_load_all_particles('2025-01-01', '2025-01-31');"

# 验证装载结果
mysql -u root -p d_hos_claude_0251230 -e \
  "SELECT particle_type, COUNT(*) as row_count FROM t_mid_detail GROUP BY particle_type;"
```

---

## ✅ 验证清单

执行完上述步骤后，检查以下项目：

| 检查项 | 预期结果 | 命令 |
|--------|---------|------|
| 表已创建 | 7个表 | SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='d_hos_claude_0251230'; |
| 粒子装载 | CASE_SETTLEMENT、CASE_DIAG、CASE_OP各一行以上 | SELECT particle_type, COUNT(*) FROM t_mid_detail GROUP BY particle_type; |
| 聚合规则 | 6条规则 | SELECT COUNT(*) FROM t_agg_rule; |
| 指标映射 | 7条映射 | SELECT COUNT(*) FROM t_item_particle_mapping; |

---

## 📋 后续工作清单

### Phase 2: 代表性验证（第2-3周）
- [ ] 选择肺炎指标做完整验证
- [ ] 对比"原始SQL"vs"粒子聚合"结果
- [ ] 微调粒子定义和聚合规则

### Phase 3: 全量扩展（第4周）
- [ ] 为全量指标配置粒子映射
- [ ] 扩展聚合规则库
- [ ] 生成全量计算SQL

### Phase 4: 生产部署（第5-6周）
- [ ] 性能优化（索引、分区）
- [ ] 数据质量检查
- [ ] 正式上线

---

## 📞 支持信息

### 文档补充
- 如需补充"最小粒子清单"DOCX，见文档3内容
- 如需整理"中间表计算SQL"MD，见脚本1-3

### 常见问题
- **粒子装载失败**: 检查 t_particle_load_task 表的错误信息
- **聚合结果不一致**: 验证粒子过滤条件和去重键配置
- **性能问题**: 检查索引是否建立

### 文件编码
- 所有脚本: UTF-8 编码
- DOCX文档: 支持中文
- SQL文件名: 包含中文，请确保MySQL支持utf8mb4

---

## 🎯 核心架构图

```
源视图 (I_MR_HOME_PAGE, I_MR_DIAGNOSIS, ...)
    ↓ [sp_load_particle_*]
t_mid_detail (统一粒子中间表)
    ├── CASE_SETTLEMENT (病例粒子)
    ├── CASE_DIAG (诊断粒子)
    ├── CASE_OP (手术粒子)
    └── ... (可扩展)
    ↓ [t_item_particle_mapping]
t_indicator_item_temp (聚合结果)
    ↓ [t_indicator.expression]
t_indicator_result (指标计算结果)
```

---

**版本**: 1.0  
**最后更新**: 2026-04-19  
**维护**: 评审指标系统团队
