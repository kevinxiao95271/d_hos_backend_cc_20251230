-- ========================================
-- 评审指标系统 - 粒子装载SQL模板库
-- 从接口视图装载数据到 t_mid_detail
-- ========================================

-- ========================================
-- 1. CASE_SETTLEMENT 粒子装载模板
-- （病例事实粒子）
-- ========================================

-- 模板说明：
-- - 粒度：一行一出院病例
-- - 唯一键：patient_id + visit_id
-- - 来源：I_MR_HOME_PAGE (病案首页)
-- - 聚合维度：discharge_dept_code, stat_month
-- - 关键衍生字段：los_days (住院日数), death_flag, total_cost

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_load_particle_case_settlement`$$
CREATE PROCEDURE `sp_load_particle_case_settlement`(
    IN p_batch_id VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_source_view VARCHAR(100)
)
COMMENT '装载 CASE_SETTLEMENT 粒子'
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    DECLARE v_error_msg VARCHAR(500);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, task_status, error_message, affected_rows)
        VALUES (p_batch_id, 'CASE_SETTLEMENT', p_source_view, 'FAILED', v_error_msg, 0);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END;

    -- 标记任务开始
    INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, start_date, end_date, task_status)
    VALUES (p_batch_id, 'CASE_SETTLEMENT', p_source_view, p_start_date, p_end_date, 'RUNNING');

    -- 装载数据
    INSERT INTO t_mid_detail (
        batch_id,
        particle_type,
        business_domain,
        source_view,
        patient_id,
        visit_id,
        case_id,
        stat_date,
        stat_month,
        stat_quarter,
        stat_year,
        discharge_dept_code,
        discharge_dept_name,
        admission_date,
        discharge_date,
        los_days,
        total_cost,
        death_flag,
        create_time
    )
    SELECT
        p_batch_id,
        'CASE_SETTLEMENT',
        'INPATIENT',
        p_source_view,
        mr.patient_id,
        mr.visit_id,
        CONCAT(mr.patient_id, '#', mr.visit_id),
        mr.discharge_date as stat_date,
        DATE_FORMAT(mr.discharge_date, '%Y-%m') as stat_month,
        CONCAT(YEAR(mr.discharge_date), '-Q', QUARTER(mr.discharge_date)) as stat_quarter,
        YEAR(mr.discharge_date) as stat_year,
        mr.discharge_dept_code,
        mr.discharge_dept_name,
        mr.admission_date,
        mr.discharge_date,
        DATEDIFF(mr.discharge_date, mr.admission_date) as los_days,
        COALESCE(mr.total_charges, 0) as total_cost,
        CASE WHEN mr.discharge_type = '死亡' THEN 1 ELSE 0 END as death_flag,
        NOW()
    FROM I_MR_HOME_PAGE mr
    WHERE mr.discharge_date BETWEEN p_start_date AND p_end_date
        AND mr.invalid_flag = 0
    ON DUPLICATE KEY UPDATE
        update_time = NOW();

    SET v_rows_affected = ROW_COUNT();

    -- 更新任务状态
    UPDATE t_particle_load_task
    SET task_status = 'SUCCESS', affected_rows = v_rows_affected, update_time = NOW()
    WHERE batch_id = p_batch_id AND particle_type = 'CASE_SETTLEMENT' AND task_status = 'RUNNING';
END$$

DELIMITER ;

-- ========================================
-- 2. CASE_DIAG 粒子装载模板
-- （诊断编码粒子）
-- ========================================

-- 模板说明：
-- - 粒度：一行一诊断编码
-- - 唯一键：patient_id + visit_id + diag_code + diag_type
-- - 来源：I_MR_DIAGNOSIS (诊断表)
-- - 用于：病种过滤、诊断统计、并发症统计

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_load_particle_case_diag`$$
CREATE PROCEDURE `sp_load_particle_case_diag`(
    IN p_batch_id VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_source_view VARCHAR(100)
)
COMMENT '装载 CASE_DIAG 粒子'
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    DECLARE v_error_msg VARCHAR(500);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, task_status, error_message, affected_rows)
        VALUES (p_batch_id, 'CASE_DIAG', p_source_view, 'FAILED', v_error_msg, 0);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END;

    INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, start_date, end_date, task_status)
    VALUES (p_batch_id, 'CASE_DIAG', p_source_view, p_start_date, p_end_date, 'RUNNING');

    -- 先从 CASE_SETTLEMENT 粒子中取出 discharge_date 作为 stat_date
    -- 然后联接诊断表获取诊断编码
    INSERT INTO t_mid_detail (
        batch_id,
        particle_type,
        business_domain,
        source_view,
        patient_id,
        visit_id,
        case_id,
        record_id,
        stat_date,
        stat_month,
        stat_quarter,
        stat_year,
        discharge_dept_code,
        discharge_dept_name,
        diag_code,
        diag_name,
        diag_type,
        create_time
    )
    SELECT
        p_batch_id,
        'CASE_DIAG',
        'INPATIENT',
        p_source_view,
        d.patient_id,
        d.visit_id,
        CONCAT(d.patient_id, '#', d.visit_id),
        CONCAT(d.patient_id, '#', d.visit_id, '#', d.diagnosis_sequence),
        s.stat_date,
        s.stat_month,
        s.stat_quarter,
        s.stat_year,
        s.discharge_dept_code,
        s.discharge_dept_name,
        d.diagnosis_code,
        d.diagnosis_name,
        d.diagnosis_type,  -- 1=主诊, 2=其他诊断
        NOW()
    FROM I_MR_DIAGNOSIS d
    INNER JOIN t_mid_detail s
        ON d.patient_id = s.patient_id
        AND d.visit_id = s.visit_id
        AND s.particle_type = 'CASE_SETTLEMENT'
        AND s.batch_id = p_batch_id
    WHERE d.invalid_flag = 0
    ON DUPLICATE KEY UPDATE
        update_time = NOW();

    SET v_rows_affected = ROW_COUNT();

    UPDATE t_particle_load_task
    SET task_status = 'SUCCESS', affected_rows = v_rows_affected, update_time = NOW()
    WHERE batch_id = p_batch_id AND particle_type = 'CASE_DIAG' AND task_status = 'RUNNING';
END$$

DELIMITER ;

-- ========================================
-- 3. CASE_OP 粒子装载模板
-- （手术事件粒子）
-- ========================================

-- 模板说明：
-- - 粒度：一行一手术事件
-- - 唯一键：patient_id + visit_id + operation_sequence
-- - 来源：I_MR_OPERATION (手术表)
-- - 用于：手术统计、四级手术占比

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_load_particle_case_op`$$
CREATE PROCEDURE `sp_load_particle_case_op`(
    IN p_batch_id VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_source_view VARCHAR(100)
)
COMMENT '装载 CASE_OP 粒子'
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    DECLARE v_error_msg VARCHAR(500);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, task_status, error_message, affected_rows)
        VALUES (p_batch_id, 'CASE_OP', p_source_view, 'FAILED', v_error_msg, 0);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END;

    INSERT INTO t_particle_load_task (batch_id, particle_type, source_view, start_date, end_date, task_status)
    VALUES (p_batch_id, 'CASE_OP', p_source_view, p_start_date, p_end_date, 'RUNNING');

    INSERT INTO t_mid_detail (
        batch_id,
        particle_type,
        business_domain,
        source_view,
        patient_id,
        visit_id,
        case_id,
        record_id,
        stat_date,
        stat_month,
        stat_quarter,
        stat_year,
        discharge_dept_code,
        discharge_dept_name,
        operation_code,
        operation_name,
        operation_sequence,
        create_time
    )
    SELECT
        p_batch_id,
        'CASE_OP',
        'INPATIENT',
        p_source_view,
        op.patient_id,
        op.visit_id,
        CONCAT(op.patient_id, '#', op.visit_id),
        CONCAT(op.patient_id, '#', op.visit_id, '#', op.operation_sequence),
        s.stat_date,
        s.stat_month,
        s.stat_quarter,
        s.stat_year,
        s.discharge_dept_code,
        s.discharge_dept_name,
        op.operation_code,
        op.operation_name,
        op.operation_sequence,
        NOW()
    FROM I_MR_OPERATION op
    INNER JOIN t_mid_detail s
        ON op.patient_id = s.patient_id
        AND op.visit_id = s.visit_id
        AND s.particle_type = 'CASE_SETTLEMENT'
        AND s.batch_id = p_batch_id
    WHERE op.operation_date BETWEEN p_start_date AND p_end_date
        AND op.invalid_flag = 0
    ON DUPLICATE KEY UPDATE
        update_time = NOW();

    SET v_rows_affected = ROW_COUNT();

    UPDATE t_particle_load_task
    SET task_status = 'SUCCESS', affected_rows = v_rows_affected, update_time = NOW()
    WHERE batch_id = p_batch_id AND particle_type = 'CASE_OP' AND task_status = 'RUNNING';
END$$

DELIMITER ;

-- ========================================
-- 4. 批量装载指标粒子的便捷存储过程
-- ========================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_load_all_particles`$$
CREATE PROCEDURE `sp_load_all_particles`(
    IN p_start_date DATE,
    IN p_end_date DATE
)
COMMENT '一次性装载所有粒子类型'
BEGIN
    DECLARE v_batch_id VARCHAR(50);
    SET v_batch_id = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

    -- 按顺序装载各粒子类型
    -- 注意：CASE_SETTLEMENT 必须首先装载（其他粒子依赖它的维度信息）
    CALL sp_load_particle_case_settlement(v_batch_id, p_start_date, p_end_date, 'I_MR_HOME_PAGE');
    CALL sp_load_particle_case_diag(v_batch_id, p_start_date, p_end_date, 'I_MR_DIAGNOSIS');
    CALL sp_load_particle_case_op(v_batch_id, p_start_date, p_end_date, 'I_MR_OPERATION');

    SELECT CONCAT('✓ 粒子装载完成 Batch: ', v_batch_id) as message;
END$$

DELIMITER ;

-- ========================================
-- 5. 使用示例
-- ========================================

-- 装载 2025年1月的所有粒子
-- CALL sp_load_all_particles('2025-01-01', '2025-01-31');

-- 查看装载任务状态
-- SELECT batch_id, particle_type, task_status, affected_rows, error_message FROM t_particle_load_task ORDER BY create_time DESC LIMIT 10;

-- 查看装载后的粒子数据
-- SELECT particle_type, COUNT(*) as row_count, COUNT(DISTINCT patient_id) as patient_count
-- FROM t_mid_detail
-- WHERE batch_id = '20250419103045'
-- GROUP BY particle_type;

-- ========================================
-- 说明
-- ========================================
-- 1. 所有粒子装载都支持 batch_id 追踪，用于数据血缘和质量检查
-- 2. CASE_DIAG 和 CASE_OP 粒子依赖 CASE_SETTLEMENT 的维度字段
--    因此必须先装载 CASE_SETTLEMENT
-- 3. 每次装载会记录影响行数、执行时间、错误信息到 t_particle_load_task
-- 4. 后续可以通过修改 sp_load_particle_* 的 SELECT 部分来适配不同的源视图字段映射
