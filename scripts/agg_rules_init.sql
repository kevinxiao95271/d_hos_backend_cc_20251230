-- ========================================
-- 评审指标系统 - 聚合规则和指标映射初始化数据
-- 为代表性指标配置聚合规则
-- ========================================

-- ========================================
-- 1. 初始化聚合规则表 (t_agg_rule)
-- ========================================

INSERT INTO `t_agg_rule` (
    `agg_code`, `agg_name`, `particle_types`,
    `filter_condition`, `group_by_fields`,
    `agg_func`, `agg_field`, `distinct_key`,
    `time_dimension`, `result_field`, `result_unit`, `status`
) VALUES
-- 规则1：病例计数（支持科室下钻）
('AGG_CASE_COUNT', '病例数统计', '["CASE_SETTLEMENT"]',
    '1=1', '["discharge_dept_code","stat_month"]',
    'COUNT', 'id', '["patient_id","visit_id"]',
    'MONTH', 'case_count', '人', 1),

-- 规则2：住院日总数（支持科室下钻）
('AGG_LOS_SUM', '住院日总数', '["CASE_SETTLEMENT"]',
    'los_days > 0', '["discharge_dept_code","stat_month"]',
    'SUM', 'los_days', '["patient_id","visit_id"]',
    'MONTH', 'los_total', '天', 1),

-- 规则3：费用总和（支持科室下钻）
('AGG_COST_SUM', '总费用统计', '["CASE_SETTLEMENT"]',
    'total_cost > 0', '["discharge_dept_code","stat_month"]',
    'SUM', 'total_cost', '["patient_id","visit_id"]',
    'MONTH', 'cost_total', '元', 1),

-- 规则4：死亡患者数
('AGG_DEATH_COUNT', '死亡患者数', '["CASE_SETTLEMENT"]',
    'death_flag = 1', '["discharge_dept_code","stat_month"]',
    'SUM', 'death_flag', '["patient_id","visit_id"]',
    'MONTH', 'death_count', '人', 1),

-- 规则5：特定诊断病种计数（例：肺炎）
('AGG_DIAG_PNEUMONIA_COUNT', '肺炎病种例数', '["CASE_DIAG"]',
    'diag_code LIKE "J13%" OR diag_code LIKE "J14%" OR diag_code LIKE "J15%" OR diag_code LIKE "J18%"',
    '["discharge_dept_code","stat_month"]',
    'COUNT', 'id', '["patient_id","visit_id"]',
    'MONTH', 'pneumonia_count', '人', 1),

-- 规则6：手术统计
('AGG_OP_COUNT', '手术总数', '["CASE_OP"]',
    'operation_code IS NOT NULL', '["discharge_dept_code","stat_month"]',
    'COUNT', 'id', '["patient_id","visit_id"]',
    'MONTH', 'operation_count', '次', 1)

ON DUPLICATE KEY UPDATE
    `agg_name` = VALUES(`agg_name`),
    `update_time` = NOW();

-- ========================================
-- 2. 初始化指标项与粒子映射表 (t_item_particle_mapping)
-- ========================================

-- 注：此处使用现有的指标项编码（来自 t_indicator_item）
-- 为代表性指标配置粒子聚合映射

INSERT INTO `t_item_particle_mapping` (
    `item_code`, `item_name`,
    `particle_code`, `particle_type`, `particle_filter`,
    `agg_code`, `agg_func`, `agg_field`, `distinct_key`,
    `time_field`, `time_dimension`, `group_by_fields`,
    `result_field`, `result_unit`,
    `supports_drill_down`, `supports_time_compare`,
    `mapping_notes`, `risk_notes`, `status`
) VALUES
-- 指标项a0050: 肺炎病种例数（分子）
('a0050', '肺炎（住院、成人）病种例数',
    'CASE_DIAG', 'CASE_DIAG',
    'diag_code LIKE "J13%" OR diag_code LIKE "J14%" OR diag_code LIKE "J15%" OR diag_code LIKE "J18%"',
    'AGG_DIAG_PNEUMONIA_COUNT', 'COUNT', 'id', '["patient_id","visit_id"]',
    'stat_date', 'MONTH', '["discharge_dept_code","stat_month"]',
    'item_value', '人', 1, 1,
    '从诊断粒子中统计肺炎ICD-10编码的例数', '需确认ICD-10编码范围是否完整', 1),

-- 指标项a0052: 出院患者占用总床日数（分子）
('a0052', '肺炎（住院、成人）出院患者占用总床日数',
    'CASE_SETTLEMENT', 'CASE_SETTLEMENT',
    'los_days > 0 AND particle_type = "CASE_SETTLEMENT" AND id IN (SELECT DISTINCT mid.id FROM t_mid_detail mid WHERE EXISTS (SELECT 1 FROM t_mid_detail d WHERE d.patient_id=mid.patient_id AND d.visit_id=mid.visit_id AND d.particle_type="CASE_DIAG" AND (d.diag_code LIKE "J13%" OR d.diag_code LIKE "J14%" OR d.diag_code LIKE "J15%" OR d.diag_code LIKE "J18%")))',
    'AGG_LOS_SUM', 'SUM', 'los_days', '["patient_id","visit_id"]',
    'stat_date', 'MONTH', '["discharge_dept_code","stat_month"]',
    'item_value', '天', 1, 1,
    '从病例粒子中统计肺炎患者的住院日总数（需过滤诊断）', '住院日计算公式需确认，是否包括未产出院等特殊情况', 1),

-- 指标项：出院患者人数（分母）
('a0051_denominator', '同期出院患者人数',
    'CASE_SETTLEMENT', 'CASE_SETTLEMENT',
    '1=1',
    'AGG_CASE_COUNT', 'COUNT', 'id', '["patient_id","visit_id"]',
    'stat_date', 'MONTH', '["discharge_dept_code","stat_month"]',
    'item_value', '人', 1, 1,
    '从病例粒子中统计所有出院患者的数量', '用作分母，包括全量病例', 1),

-- 指标项：住院日（由表达式a0052/a0051_denominator计算）
-- 此行仅用作标记，实际计算在 t_indicator 表的 expression 字段

-- 指标项：总费用统计
('a0060', '出院患者总费用',
    'CASE_SETTLEMENT', 'CASE_SETTLEMENT',
    'total_cost > 0',
    'AGG_COST_SUM', 'SUM', 'total_cost', '["patient_id","visit_id"]',
    'stat_date', 'MONTH', '["discharge_dept_code","stat_month"]',
    'item_value', '元', 1, 1,
    '从病例粒子中统计出院患者的费用总额', '需确认费用统计口径（是否包括自费等）', 1),

-- 指标项：死亡患者数
('a0070', '死亡患者数',
    'CASE_SETTLEMENT', 'CASE_SETTLEMENT',
    'death_flag = 1',
    'AGG_DEATH_COUNT', 'SUM', 'death_flag', '["patient_id","visit_id"]',
    'stat_date', 'MONTH', '["discharge_dept_code","stat_month"]',
    'item_value', '人', 1, 1,
    '从病例粒子中统计院内死亡的患者数', '死亡标志的准确性依赖源数据质量', 1)

ON DUPLICATE KEY UPDATE
    `particle_type` = VALUES(`particle_type`),
    `particle_filter` = VALUES(`particle_filter`),
    `update_time` = NOW();

-- ========================================
-- 3. 生成指标项聚合SQL的动态存储过程
-- ========================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_generate_item_agg_sql`$$
CREATE PROCEDURE `sp_generate_item_agg_sql`(
    IN p_item_code VARCHAR(50),
    IN p_batch_id VARCHAR(50),
    IN p_time_dimension VARCHAR(20)
)
COMMENT '根据指标项映射动态生成聚合SQL'
READS SQL DATA
BEGIN
    DECLARE v_particle_type VARCHAR(50);
    DECLARE v_particle_filter VARCHAR(500);
    DECLARE v_agg_func VARCHAR(50);
    DECLARE v_agg_field VARCHAR(100);
    DECLARE v_distinct_key VARCHAR(500);
    DECLARE v_group_by_fields VARCHAR(500);
    DECLARE v_sql TEXT;

    -- 从映射表中读取配置
    SELECT
        particle_type, particle_filter, agg_func, agg_field, distinct_key, group_by_fields
    INTO
        v_particle_type, v_particle_filter, v_agg_func, v_agg_field, v_distinct_key, v_group_by_fields
    FROM t_item_particle_mapping
    WHERE item_code = p_item_code
    LIMIT 1;

    IF v_particle_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Item code not found: ', p_item_code);
    END IF;

    -- 构造聚合SQL
    SET v_sql = CONCAT(
        'SELECT ',
            'stat_month, discharge_dept_code, ',
            CASE v_agg_func
                WHEN 'COUNT' THEN CONCAT('COUNT(DISTINCT CONCAT(patient_id, "#", visit_id)) as item_value')
                WHEN 'SUM' THEN CONCAT('SUM(', v_agg_field, ') as item_value')
                WHEN 'AVG' THEN CONCAT('AVG(', v_agg_field, ') as item_value')
                ELSE CONCAT(v_agg_func, '(', v_agg_field, ') as item_value')
            END,
        ' FROM t_mid_detail ',
        'WHERE batch_id = "', p_batch_id, '" ',
            'AND particle_type = "', v_particle_type, '" ',
            'AND (', v_particle_filter, ') ',
        'GROUP BY stat_month, discharge_dept_code '
    );

    -- 返回生成的SQL（用于调试）
    SELECT v_sql as generated_sql, p_item_code as item_code;
END$$

DELIMITER ;

-- ========================================
-- 4. 聚合SQL执行存储过程
-- ========================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_execute_item_aggregation`$$
CREATE PROCEDURE `sp_execute_item_aggregation`(
    IN p_batch_id VARCHAR(50),
    IN p_item_code VARCHAR(50)
)
COMMENT '执行指标项从粒子层的聚合'
MODIFIES SQL DATA
BEGIN
    DECLARE v_particle_type VARCHAR(50);
    DECLARE v_particle_filter VARCHAR(500);
    DECLARE v_agg_func VARCHAR(50);
    DECLARE v_agg_field VARCHAR(100);
    DECLARE v_distinct_key VARCHAR(500);
    DECLARE v_group_by_fields VARCHAR(500);
    DECLARE v_sql TEXT;
    DECLARE v_rows INT;
    DECLARE v_error_msg VARCHAR(500);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        INSERT INTO t_item_agg_task (batch_id, item_code, task_status, error_message)
        VALUES (p_batch_id, p_item_code, 'FAILED', v_error_msg);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END;

    -- 读取映射配置
    SELECT
        particle_type, particle_filter, agg_func, agg_field, distinct_key, group_by_fields
    INTO
        v_particle_type, v_particle_filter, v_agg_func, v_agg_field, v_distinct_key, v_group_by_fields
    FROM t_item_particle_mapping
    WHERE item_code = p_item_code
    LIMIT 1;

    IF v_particle_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Item code not found: ', p_item_code);
    END IF;

    -- 记录任务开始
    INSERT INTO t_item_agg_task (batch_id, item_code, task_status)
    VALUES (p_batch_id, p_item_code, 'RUNNING');

    -- 执行聚合（这里演示，实际需要通过动态SQL执行）
    -- 简化版本：直接调用预定义的聚合规则
    INSERT INTO t_indicator_item_temp (batch_id, item_code, start_date, end_date, result_value, dept_code, dept_name)
    SELECT
        p_batch_id,
        p_item_code,
        DATE_FORMAT(MIN(stat_date), '%Y-%m-01'),
        DATE_FORMAT(MAX(stat_date), '%Y-%m-%d'),
        CASE
            WHEN v_agg_func = 'COUNT' THEN COUNT(DISTINCT CONCAT(patient_id, '#', visit_id))
            WHEN v_agg_func = 'SUM' THEN SUM(CAST(JSON_EXTRACT(ext_json, '$."' + v_agg_field + '"') AS DECIMAL(15,4)))
            ELSE SUM(CAST(JSON_EXTRACT(ext_json, '$."' + v_agg_field + '"') AS DECIMAL(15,4)))
        END,
        discharge_dept_code,
        discharge_dept_name
    FROM t_mid_detail
    WHERE batch_id = p_batch_id
        AND particle_type = v_particle_type
    GROUP BY stat_month, discharge_dept_code, discharge_dept_name;

    SET v_rows = ROW_COUNT();

    -- 更新任务状态
    UPDATE t_item_agg_task
    SET task_status = 'SUCCESS', result_rows = v_rows
    WHERE batch_id = p_batch_id AND item_code = p_item_code AND task_status = 'RUNNING';
END$$

DELIMITER ;

-- ========================================
-- 5. 查询示例
-- ========================================

-- 查看已定义的聚合规则
-- SELECT agg_code, agg_name, agg_func, agg_field, result_unit FROM t_agg_rule WHERE status = 1;

-- 查看指标项映射配置
-- SELECT item_code, item_name, particle_type, agg_func, result_unit FROM t_item_particle_mapping WHERE status = 1;

-- 生成指标项a0050的聚合SQL（用于检查）
-- CALL sp_generate_item_agg_sql('a0050', 'batch_001', 'MONTH');

-- ========================================
-- 说明
-- ========================================
-- 1. 聚合规则表 (t_agg_rule) 定义了常用的聚合模式
-- 2. 指标项映射表 (t_item_particle_mapping) 为每个指标项指定了具体的粒子和聚合规则
-- 3. sp_generate_item_agg_sql 可以根据映射配置动态生成 SQL（用于验证逻辑）
-- 4. sp_execute_item_aggregation 执行聚合并将结果保存到临时表 t_indicator_item_temp
-- 5. 后续可以从 t_indicator_item_temp 读取结果，结合 t_indicator 的 expression 计算最终指标值
