-- ===========================================
-- 将 4.5.1.2.2、4.5.1.3.2、4.5.1.4.2、4.5.2.1.2、4.5.2.2.2、4.5.2.3.2 的采集来源统一为 4.5.1.1.2（同期手术患者的总例数）
-- 适用：库中指标已存在但尚未配置 SOURCE_KPI_ID / 数据表未改为视图引用的环境
-- 前置：KPI_ITEM_CATEGORY_REL 中已存在 CATEGORY_CODE = 4.5.1.1.2 的分母指标
-- ===========================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `tmp_sync_denominator_source_45112`$$

CREATE PROCEDURE `tmp_sync_denominator_source_45112`()
BEGIN
    DECLARE v_src INT DEFAULT NULL;
    DECLARE v_id_5122 INT DEFAULT NULL;
    DECLARE v_id_5132 INT DEFAULT NULL;
    DECLARE v_id_5142 INT DEFAULT NULL;
    DECLARE v_id_5212 INT DEFAULT NULL;
    DECLARE v_id_5222 INT DEFAULT NULL;
    DECLARE v_id_5232 INT DEFAULT NULL;

    SELECT k.ID INTO v_src FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1;

    IF v_src IS NULL THEN
        SELECT '错误：未找到编码 4.5.1.1.2 的指标，请先执行 4.5.1.1_术前评估完成率.sql' AS 检查结果;
    ELSE
        UPDATE KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE IN (
            '4.5.1.2.2', '4.5.1.3.2', '4.5.1.4.2', '4.5.2.1.2', '4.5.2.2.2', '4.5.2.3.2'
        )
        SET k.SOURCE_KPI_ID = v_src, k.COLLECTION_MODE = 'datasource'
        WHERE k.INVALID = 0;

        SELECT k.ID INTO v_id_5122 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
        SELECT k.ID INTO v_id_5132 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
        SELECT k.ID INTO v_id_5142 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
        SELECT k.ID INTO v_id_5212 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
        SELECT k.ID INTO v_id_5222 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
        SELECT k.ID INTO v_id_5232 FROM KPI_ITEM k
        INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.2.3.2' WHERE k.INVALID = 0 LIMIT 1;

        IF v_id_5122 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5122, v_src); END IF;
        IF v_id_5132 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5132, v_src); END IF;
        IF v_id_5142 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5142, v_src); END IF;
        IF v_id_5212 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5212, v_src); END IF;
        IF v_id_5222 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5222, v_src); END IF;
        IF v_id_5232 IS NOT NULL THEN CALL sp_kpi_replace_with_source_views(v_id_5232, v_src); END IF;

        SELECT CONCAT('已完成：SOURCE_KPI_ID=', v_src, '；已处理上述分母指标视图（若存在）') AS 检查结果;
    END IF;
END$$

DELIMITER ;

CALL tmp_sync_denominator_source_45112();
DROP PROCEDURE IF EXISTS `tmp_sync_denominator_source_45112`;
