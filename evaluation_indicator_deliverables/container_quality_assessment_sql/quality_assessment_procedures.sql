-- 质控考评模块存储过程脚本
-- 创建时间: 2024-12-27
-- 版本: 1.0.0

DELIMITER $$

-- 1. 获取考评记录列表
CREATE PROCEDURE `sp_quality_assessment_list`(
    IN p_page INT,
    IN p_size INT,
    IN p_keyword VARCHAR(200),
    IN p_status VARCHAR(20),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_dept VARCHAR(200)
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total INT DEFAULT 0;
    
    -- 设置默认值
    SET p_page = IFNULL(p_page, 1);
    SET p_size = IFNULL(p_size, 20);
    SET v_offset = (p_page - 1) * p_size;
    
    -- 获取总数
    SELECT COUNT(*) INTO v_total
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD` a
    WHERE a.INVALID = 0
        AND (p_keyword IS NULL OR p_keyword = '' OR 
             a.ASSESSMENT_NAME LIKE CONCAT('%', p_keyword, '%') OR
             a.ASSESSMENT_DEPT LIKE CONCAT('%', p_keyword, '%'))
        AND (p_status IS NULL OR p_status = '' OR a.ASSESSMENT_STATUS = p_status)
        AND (p_start_date IS NULL OR a.ASSESSMENT_DATE >= p_start_date)
        AND (p_end_date IS NULL OR a.ASSESSMENT_DATE <= p_end_date)
        AND (p_dept IS NULL OR p_dept = '' OR a.ASSESSMENT_DEPT = p_dept);
    
    -- 获取分页数据
    SELECT 
        a.ID,
        a.ASSESSMENT_CODE,
        a.TEMPLATE_ID,
        a.ASSESSMENT_NAME,
        a.ASSESSMENT_DATE,
        a.ASSESSMENT_TYPE,
        a.ASSESSMENT_STATUS,
        a.ASSESSOR,
        a.ASSESSMENT_DEPT,
        a.TOTAL_SCORE,
        a.MAX_SCORE,
        a.PASS_SCORE,
        a.ASSESSMENT_RESULT,
        a.REMARKS,
        a.CREATE_USER,
        a.CREATE_TIME,
        a.UPDATE_USER,
        a.UPDATE_TIME,
        t.TEMPLATE_NAME as template_name,
        t.TOTAL_SCORE as template_total_score
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD` a
    LEFT JOIN `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` t ON a.TEMPLATE_ID = t.ID
    WHERE a.INVALID = 0
        AND (p_keyword IS NULL OR p_keyword = '' OR 
             a.ASSESSMENT_NAME LIKE CONCAT('%', p_keyword, '%') OR
             a.ASSESSMENT_DEPT LIKE CONCAT('%', p_keyword, '%'))
        AND (p_status IS NULL OR p_status = '' OR a.ASSESSMENT_STATUS = p_status)
        AND (p_start_date IS NULL OR a.ASSESSMENT_DATE >= p_start_date)
        AND (p_end_date IS NULL OR a.ASSESSMENT_DATE <= p_end_date)
        AND (p_dept IS NULL OR p_dept = '' OR a.ASSESSMENT_DEPT = p_dept)
    ORDER BY a.CREATE_TIME DESC
    LIMIT v_offset, p_size;
    
    -- 返回总数
    SELECT v_total as total;
END$$

-- 2. 获取考评记录详情
CREATE PROCEDURE `sp_quality_assessment_detail`(
    IN p_id INT
)
BEGIN
    -- 获取考评基本信息
    SELECT 
        a.ID,
        a.ASSESSMENT_CODE,
        a.TEMPLATE_ID,
        a.ASSESSMENT_NAME,
        a.ASSESSMENT_DATE,
        a.ASSESSMENT_TYPE,
        a.ASSESSMENT_STATUS,
        a.ASSESSOR,
        a.ASSESSMENT_DEPT,
        a.TOTAL_SCORE,
        a.MAX_SCORE,
        a.PASS_SCORE,
        a.ASSESSMENT_RESULT,
        a.REMARKS,
        a.CREATE_USER,
        a.CREATE_TIME,
        a.UPDATE_USER,
        a.UPDATE_TIME,
        t.TEMPLATE_NAME as template_name,
        t.DESCRIPTION as template_description,
        t.TOTAL_SCORE as template_total_score,
        t.PASS_SCORE as template_pass_score
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD` a
    LEFT JOIN `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` t ON a.TEMPLATE_ID = t.ID
    WHERE a.ID = p_id AND a.INVALID = 0;
    
    -- 获取考评细则结果
    SELECT 
        ir.ID,
        ir.ASSESSMENT_ID,
        ir.TEMPLATE_ITEM_ID,
        ir.IS_QUALIFIED,
        ir.ACTUAL_SCORE,
        ir.EVALUATION_REMARK,
        ir.CREATE_TIME,
        ir.UPDATE_TIME,
        ti.ITEM_NAME,
        ti.DESCRIPTION,
        ti.MAX_SCORE,
        ti.SORT_ORDER,
        ti.ITEM_TYPE,
        ti.REQUIRED
    FROM `MEDICAL_QUALITY_ASSESSMENT_ITEM_RESULT` ir
    LEFT JOIN `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM` ti ON ir.TEMPLATE_ITEM_ID = ti.ID
    WHERE ir.ASSESSMENT_ID = p_id
    ORDER BY ti.SORT_ORDER;
    
    -- 获取附件列表
    SELECT 
        ID,
        ASSESSMENT_ID,
        ITEM_RESULT_ID,
        FILE_NAME,
        FILE_PATH,
        FILE_SIZE,
        FILE_TYPE,
        UPLOAD_USER,
        UPLOAD_TIME
    FROM `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT`
    WHERE ASSESSMENT_ID = p_id AND INVALID = 0
    ORDER BY UPLOAD_TIME DESC;
END$$

-- 3. 创建考评记录
CREATE PROCEDURE `sp_quality_assessment_create`(
    IN p_assessment_code VARCHAR(50),
    IN p_template_id INT,
    IN p_assessment_name VARCHAR(200),
    IN p_assessment_date DATE,
    IN p_assessment_type VARCHAR(50),
    IN p_assessor VARCHAR(100),
    IN p_assessment_dept VARCHAR(200),
    IN p_max_score DECIMAL(8,2),
    IN p_pass_score DECIMAL(8,2),
    IN p_remarks TEXT,
    IN p_create_user VARCHAR(50)
)
BEGIN
    DECLARE v_id INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '创建考评记录失败';
    END;
    
    START TRANSACTION;
    
    -- 插入考评记录
    INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_RECORD` (
        ASSESSMENT_CODE,
        TEMPLATE_ID,
        ASSESSMENT_NAME,
        ASSESSMENT_DATE,
        ASSESSMENT_TYPE,
        ASSESSMENT_STATUS,
        ASSESSOR,
        ASSESSMENT_DEPT,
        MAX_SCORE,
        PASS_SCORE,
        REMARKS,
        CREATE_USER
    ) VALUES (
        p_assessment_code,
        p_template_id,
        p_assessment_name,
        p_assessment_date,
        p_assessment_type,
        'draft',
        p_assessor,
        p_assessment_dept,
        p_max_score,
        p_pass_score,
        p_remarks,
        p_create_user
    );
    
    SET v_id = LAST_INSERT_ID();
    
    -- 初始化考评细则结果
    INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_ITEM_RESULT` (
        ASSESSMENT_ID,
        TEMPLATE_ITEM_ID,
        ACTUAL_SCORE
    )
    SELECT 
        v_id,
        ID,
        0.00
    FROM `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM`
    WHERE TEMPLATE_ID = p_template_id;
    
    COMMIT;
    
    -- 返回创建的记录ID
    SELECT v_id as id;
END$$

-- 4. 更新考评记录
CREATE PROCEDURE `sp_quality_assessment_update`(
    IN p_id INT,
    IN p_assessment_name VARCHAR(200),
    IN p_assessment_date DATE,
    IN p_assessment_type VARCHAR(50),
    IN p_assessor VARCHAR(100),
    IN p_assessment_dept VARCHAR(200),
    IN p_remarks TEXT,
    IN p_update_user VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '更新考评记录失败';
    END;
    
    START TRANSACTION;
    
    -- 更新考评记录
    UPDATE `MEDICAL_QUALITY_ASSESSMENT_RECORD` SET
        ASSESSMENT_NAME = p_assessment_name,
        ASSESSMENT_DATE = p_assessment_date,
        ASSESSMENT_TYPE = p_assessment_type,
        ASSESSOR = p_assessor,
        ASSESSMENT_DEPT = p_assessment_dept,
        REMARKS = p_remarks,
        UPDATE_USER = p_update_user,
        UPDATE_TIME = NOW()
    WHERE ID = p_id AND INVALID = 0;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '考评记录不存在或已删除';
    END IF;
    
    COMMIT;
    
    SELECT 1 as success;
END$$

-- 5. 删除考评记录
CREATE PROCEDURE `sp_quality_assessment_delete`(
    IN p_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '删除考评记录失败';
    END;
    
    START TRANSACTION;
    
    -- 软删除考评记录
    UPDATE `MEDICAL_QUALITY_ASSESSMENT_RECORD` SET
        INVALID = 1,
        UPDATE_TIME = NOW()
    WHERE ID = p_id AND INVALID = 0;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '考评记录不存在或已删除';
    END IF;
    
    -- 软删除相关附件
    UPDATE `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT` SET
        INVALID = 1
    WHERE ASSESSMENT_ID = p_id AND INVALID = 0;
    
    COMMIT;
    
    SELECT 1 as success;
END$$

-- 6. 提交考评结果
CREATE PROCEDURE `sp_quality_assessment_submit`(
    IN p_id INT,
    IN p_total_score DECIMAL(8,2),
    IN p_assessment_result VARCHAR(20),
    IN p_update_user VARCHAR(50)
)
BEGIN
    DECLARE v_max_score DECIMAL(8,2) DEFAULT 0;
    DECLARE v_pass_score DECIMAL(8,2) DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '提交考评结果失败';
    END;
    
    START TRANSACTION;
    
    -- 获取模板信息
    SELECT MAX_SCORE, PASS_SCORE INTO v_max_score, v_pass_score
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD`
    WHERE ID = p_id AND INVALID = 0;
    
    IF v_max_score = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '考评记录不存在或模板信息错误';
    END IF;
    
    -- 更新考评记录
    UPDATE `MEDICAL_QUALITY_ASSESSMENT_RECORD` SET
        TOTAL_SCORE = p_total_score,
        ASSESSMENT_RESULT = p_assessment_result,
        ASSESSMENT_STATUS = 'completed',
        UPDATE_USER = p_update_user,
        UPDATE_TIME = NOW()
    WHERE ID = p_id AND INVALID = 0;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '更新考评记录失败';
    END IF;
    
    COMMIT;
    
    SELECT 1 as success;
END$$

-- 7. 获取考评表模板列表
CREATE PROCEDURE `sp_quality_assessment_template_list`()
BEGIN
    SELECT 
        ID,
        TEMPLATE_CODE,
        TEMPLATE_NAME,
        DESCRIPTION,
        TOTAL_SCORE,
        PASS_SCORE,
        ITEM_COUNT,
        STATUS,
        CREATE_TIME
    FROM `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE`
    WHERE INVALID = 0 AND STATUS = 1
    ORDER BY CREATE_TIME DESC;
END$$

-- 8. 获取考评表模板详情
CREATE PROCEDURE `sp_quality_assessment_template_detail`(
    IN p_id INT
)
BEGIN
    SELECT 
        ID,
        TEMPLATE_CODE,
        TEMPLATE_NAME,
        DESCRIPTION,
        TOTAL_SCORE,
        PASS_SCORE,
        ITEM_COUNT,
        STATUS,
        CREATE_TIME
    FROM `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE`
    WHERE ID = p_id AND INVALID = 0 AND STATUS = 1;
END$$

-- 9. 获取考评表细则项目
CREATE PROCEDURE `sp_quality_assessment_template_items`(
    IN p_template_id INT
)
BEGIN
    SELECT 
        ID,
        TEMPLATE_ID,
        ITEM_NAME,
        DESCRIPTION,
        MAX_SCORE,
        SORT_ORDER,
        ITEM_TYPE,
        REQUIRED
    FROM `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM`
    WHERE TEMPLATE_ID = p_template_id
    ORDER BY SORT_ORDER;
END$$

-- 10. 获取可考评部门列表
CREATE PROCEDURE `sp_quality_assessment_dept_list`()
BEGIN
    SELECT 
        DEPT_ID as id,
        DEPT_NAME as name,
        DEPT_CODE as code,
        CAN_ASSESS,
        ASSESSMENT_LEVEL
    FROM `MEDICAL_QUALITY_ASSESSMENT_DEPT_PERMISSION`
    WHERE CAN_ASSESS = 1
    ORDER BY DEPT_NAME;
END$$

-- 11. 上传考评相关文件
CREATE PROCEDURE `sp_quality_assessment_file_upload`(
    IN p_assessment_id INT,
    IN p_item_result_id INT,
    IN p_file_name VARCHAR(255),
    IN p_file_path VARCHAR(500),
    IN p_file_size BIGINT,
    IN p_file_type VARCHAR(100),
    IN p_upload_user VARCHAR(50)
)
BEGIN
    DECLARE v_id INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '文件上传失败';
    END;
    
    START TRANSACTION;
    
    -- 插入附件记录
    INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT` (
        ASSESSMENT_ID,
        ITEM_RESULT_ID,
        FILE_NAME,
        FILE_PATH,
        FILE_SIZE,
        FILE_TYPE,
        UPLOAD_USER
    ) VALUES (
        p_assessment_id,
        p_item_result_id,
        p_file_name,
        p_file_path,
        p_file_size,
        p_file_type,
        p_upload_user
    );
    
    SET v_id = LAST_INSERT_ID();
    
    COMMIT;
    
    -- 返回文件信息
    SELECT 
        v_id as fileId,
        p_file_name as fileName,
        p_file_path as fileUrl
    FROM DUAL;
END$$

-- 12. 获取考评相关文件列表
CREATE PROCEDURE `sp_quality_assessment_file_list`(
    IN p_assessment_id INT,
    IN p_item_result_id INT
)
BEGIN
    SELECT 
        ID,
        ASSESSMENT_ID,
        ITEM_RESULT_ID,
        FILE_NAME,
        FILE_PATH,
        FILE_SIZE,
        FILE_TYPE,
        UPLOAD_USER,
        UPLOAD_TIME
    FROM `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT`
    WHERE INVALID = 0
        AND (p_assessment_id IS NULL OR ASSESSMENT_ID = p_assessment_id)
        AND (p_item_result_id IS NULL OR ITEM_RESULT_ID = p_item_result_id)
    ORDER BY UPLOAD_TIME DESC;
END$$

-- 13. 删除考评相关文件
CREATE PROCEDURE `sp_quality_assessment_file_delete`(
    IN p_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '删除文件失败';
    END;
    
    START TRANSACTION;
    
    -- 软删除文件记录
    UPDATE `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT` SET
        INVALID = 1
    WHERE ID = p_id AND INVALID = 0;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '文件记录不存在或已删除';
    END IF;
    
    COMMIT;
    
    SELECT 1 as success;
END$$

-- 14. 获取考评统计信息
CREATE PROCEDURE `sp_quality_assessment_statistics`(
    IN p_dept VARCHAR(200),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    -- 部门考评统计
    SELECT 
        ASSESSMENT_DEPT,
        COUNT(*) as total_count,
        SUM(CASE WHEN ASSESSMENT_STATUS = 'completed' THEN 1 ELSE 0 END) as completed_count,
        SUM(CASE WHEN ASSESSMENT_STATUS = 'draft' THEN 1 ELSE 0 END) as draft_count,
        SUM(CASE WHEN ASSESSMENT_STATUS = 'in_progress' THEN 1 ELSE 0 END) as in_progress_count,
        AVG(TOTAL_SCORE) as avg_score,
        AVG(CASE WHEN MAX_SCORE > 0 THEN (TOTAL_SCORE / MAX_SCORE) * 100 ELSE 0 END) as avg_percentage
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD`
    WHERE INVALID = 0
        AND (p_dept IS NULL OR p_dept = '' OR ASSESSMENT_DEPT = p_dept)
        AND (p_start_date IS NULL OR ASSESSMENT_DATE >= p_start_date)
        AND (p_end_date IS NULL OR ASSESSMENT_DATE <= p_end_date)
    GROUP BY ASSESSMENT_DEPT
    ORDER BY total_count DESC;
    
    -- 考评结果分布
    SELECT 
        ASSESSMENT_RESULT,
        COUNT(*) as count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD` WHERE INVALID = 0), 2) as percentage
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD`
    WHERE INVALID = 0 
        AND ASSESSMENT_STATUS = 'completed'
        AND (p_dept IS NULL OR p_dept = '' OR ASSESSMENT_DEPT = p_dept)
        AND (p_start_date IS NULL OR ASSESSMENT_DATE >= p_start_date)
        AND (p_end_date IS NULL OR ASSESSMENT_DATE <= p_end_date)
    GROUP BY ASSESSMENT_RESULT
    ORDER BY count DESC;
    
    -- 月度考评趋势
    SELECT 
        DATE_FORMAT(ASSESSMENT_DATE, '%Y-%m') as month,
        COUNT(*) as count,
        AVG(TOTAL_SCORE) as avg_score
    FROM `MEDICAL_QUALITY_ASSESSMENT_RECORD`
    WHERE INVALID = 0 
        AND ASSESSMENT_STATUS = 'completed'
        AND (p_dept IS NULL OR p_dept = '' OR ASSESSMENT_DEPT = p_dept)
        AND (p_start_date IS NULL OR ASSESSMENT_DATE >= p_start_date)
        AND (p_end_date IS NULL OR ASSESSMENT_DATE <= p_end_date)
    GROUP BY DATE_FORMAT(ASSESSMENT_DATE, '%Y-%m')
    ORDER BY month DESC
    LIMIT 12;
END$$

DELIMITER ;
