-- ===========================================
-- 第四章 0405～0455 分母指标 SOURCE_KPI_ID 维护（源于清单聚类 + SQL 编码映射）
-- 适用：库中指标已存在但尚未配置 SOURCE_KPI_ID / 数据表未改为视图引用的环境
-- 前置：各病种「源分母」注册脚本已执行，KPI_ITEM_CATEGORY_REL 中已存在对应 CATEGORY_CODE
-- 说明：对每个 (派生分母编码 → 源分母编码) 执行 UPDATE 与 sp_kpi_replace_with_source_views
-- 末段「0413～0455 单病种资源消耗」与注册脚本中 @source_kpi_id 一致，后执行以覆盖前序链式映射
-- 更新末段：node src/views/interface_system_kpi/indicators/scripts/gen_denominator_source_patch_ch413_455.mjs
-- ===========================================

DELIMITER $$

DROP PROCEDURE IF EXISTS `tmp_sync_denominator_source_ch4_0405_0455`$$

CREATE PROCEDURE `tmp_sync_denominator_source_ch4_0405_0455`()
BEGIN
    DECLARE v_src INT DEFAULT NULL;
    DECLARE v_der INT DEFAULT NULL;

    -- 0405 派生 4.5.1.2.2 ← 源 4.5.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0405 派生 4.5.2.2.2 ← 源 4.5.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.5.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0406 派生 4.6.1.2.2 ← 源 4.6.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.6.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.6.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0406 派生 4.6.2.2.2 ← 源 4.6.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.6.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.6.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.1.2.2 ← 源 4.7.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.1.3.2 ← 源 4.7.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.1.4.2 ← 源 4.7.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.1.5.2 ← 源 4.7.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.2.1.2 ← 源 4.7.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0407 派生 4.7.2.2.2 ← 源 4.7.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.7.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.1.2.2 ← 源 4.8.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.1.3.2 ← 源 4.8.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.1.4.2 ← 源 4.8.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.1.5.2 ← 源 4.8.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.2.1.2 ← 源 4.8.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0408 派生 4.8.2.2.2 ← 源 4.8.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.8.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0409 派生 4.9.1.2.2 ← 源 4.9.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0409 派生 4.9.1.5.2 ← 源 4.9.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0409 派生 4.9.1.6.2 ← 源 4.9.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0409 派生 4.9.2.1.2 ← 源 4.9.1.7.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.7.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0409 派生 4.9.2.2.2 ← 源 4.9.1.7.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.1.7.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.9.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0410 派生 4.10.1.3.2 ← 源 4.10.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.10.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.10.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0410 派生 4.10.2.2.2 ← 源 4.10.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.10.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.10.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0411 派生 4.11.1.2.2 ← 源 4.11.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0411 派生 4.11.1.4.2 ← 源 4.11.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0411 派生 4.11.2.1.2 ← 源 4.11.1.5.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0411 派生 4.11.2.2.2 ← 源 4.11.1.5.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.11.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0412 派生 4.12.1.4.2 ← 源 4.12.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0412 派生 4.12.2.1.2 ← 源 4.12.1.5.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0412 派生 4.12.2.2.2 ← 源 4.12.1.5.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.12.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.2.2.2 ← 源 4.13.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.1.4.2 ← 源 4.14.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.2.1.2 ← 源 4.14.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.2.2.2 ← 源 4.14.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.2.1.2 ← 源 4.15.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.2.2.2 ← 源 4.15.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.1.3.2 ← 源 4.16.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.2.1.2 ← 源 4.16.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.2.2.2 ← 源 4.16.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.1.3.2 ← 源 4.17.1.1.2（与注册脚本一致，取消经 4.17.1.2.2 链式指向）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.2.2.2 ← 源 4.17.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.1.2.2 ← 源 4.18.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.2.1.2 ← 源 4.18.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.2.2.2 ← 源 4.18.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0419 派生 4.19.1.2.2 ← 源 4.19.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0419 派生 4.19.1.3.2 ← 源 4.19.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0419 派生 4.19.2.2.2 ← 源 4.19.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.3.2 ← 源 4.20.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.4.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.2.1.2 ← 源 4.20.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.2.2.2 ← 源 4.20.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.1.2.2 ← 源 4.21.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.1.3.2 ← 源 4.21.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.2.1.2 ← 源 4.21.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.2.2.2 ← 源 4.21.1.1.2（与资源消耗注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.1.2.2 ← 源 4.22.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.2.2.2 ← 源 4.22.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.4.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.5.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.2.2.2 ← 源 4.23.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.4.2 ← 源 4.24.3.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.3.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.5.2 ← 源 4.24.3.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.3.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.2.2.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0425 派生 4.25.1.3.2 ← 源 4.25.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0425 派生 4.25.2.2.2 ← 源 4.25.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0426 派生 4.26.2.2.2 ← 源 4.26.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0427 派生 4.27.2.2.2 ← 源 4.27.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.2.2.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.1.2.2 ← 源 4.29.1.1.2（病理诊断率分母与主指标「同期该肿瘤手术患者总数」一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.1.6.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.2.1.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.2.2.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.2.1.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.2.2.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.1.2.2 ← 源 4.31.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.1.3.2 ← 源 4.31.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.2.2.2 ← 源 4.31.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.2.1.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.2.2.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.1.2.2 ← 源 4.33.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.2.1.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.2.2.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.1.3.2 ← 源 4.34.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.2.1.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.2.2.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.1.2.2 ← 源 4.35.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.2.1.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.2.2.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0436 派生 4.36.1.4.2 ← 源 4.36.1.2.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.36.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.36.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0437 派生 4.37.1.2.2 ← 源 4.37.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.37.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.37.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.1.2.2 ← 源 4.38.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.2.1.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.2.2.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.2.1.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.2.2.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.1.2.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.1.3.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.2.1.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.2.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.3.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.4.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.5.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.6.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.1.7.2 ← 源 4.41.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.7.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.2.2.2 ← 源 4.41.2.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.1.3.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.1.4.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.2.1.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.2.2.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0443 派生 4.43.1.2.2 ← 源 4.43.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0443 派生 4.43.1.3.2 ← 源 4.43.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0444 派生 4.44.1.2.2 ← 源 4.44.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.44.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.44.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0445 派生 4.45.1.2.2 ← 源 4.45.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0445 派生 4.45.1.3.2 ← 源 4.45.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0445 派生 4.45.1.4.2 ← 源 4.45.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.45.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0446 派生 4.46.1.2.2 ← 源 4.46.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.46.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.46.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0446 派生 4.46.1.3.2 ← 源 4.46.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.46.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.46.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.1.2.2 ← 源 4.47.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.1.3.2 ← 源 4.47.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.1.4.2 ← 源 4.47.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.2.1.2 ← 源 4.47.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.2.2.2 ← 源 4.47.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.1.2.2 ← 源 4.48.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.1.3.2 ← 源 4.48.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.1.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.2.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.3.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.1.2.2 ← 源 4.49.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.1.3.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.1.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.2.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.3.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.1.2.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.1.3.2 ← 源 4.50.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.1.4.2 ← 源 4.50.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.1.5.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.2.1.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.2.2.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0451 派生 4.51.1.2.2 ← 源 4.51.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0451 派生 4.51.1.3.2 ← 源 4.51.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0451 派生 4.51.1.4.2 ← 源 4.51.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.1.2.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.1.3.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.2.1.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.2.2.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0453 派生 4.53.1.2.2 ← 源 4.53.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0453 派生 4.53.2.1.2 ← 源 4.53.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0453 派生 4.53.2.2.2 ← 源 4.53.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.1.2.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.1.3.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.2.1.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.2.2.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.1.2.2 ← 源 4.55.1.1.2
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.1.3.2 ← 源 4.55.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.2.1.2 ← 源 4.55.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.2.2.2 ← 源 4.55.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- ========== BEGIN: 0413～0455 资源消耗注册脚本对齐（node gen_denominator_source_patch_ch413_455.mjs 生成）==========
    -- 0413～0455 单病种资源消耗：与注册脚本中 SOURCE_KPI 一致（补全/纠正链式映射）
    -- 说明：若此前已按「次均→平均住院日分母」链式配置，此处按注册脚本改为直接指向源分母等指标
    -- 0413 派生 4.13.1.2.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.1.3.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.1.4.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.1.5.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.2.1.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0413 派生 4.13.2.2.2 ← 源 4.13.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.13.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.1.2.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.1.3.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.1.4.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.1.5.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.2.1.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0414 派生 4.14.2.2.2 ← 源 4.14.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.1.2.2 ← 源 4.15.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.1.3.2 ← 源 4.15.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.1.4.2 ← 源 4.15.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.2.1.2 ← 源 4.15.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0415 派生 4.15.2.2.2 ← 源 4.15.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.15.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.1.2.2 ← 源 4.16.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.1.3.2 ← 源 4.16.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.1.4.2 ← 源 4.16.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.2.1.2 ← 源 4.16.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0416 派生 4.16.2.2.2 ← 源 4.16.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.1.2.2 ← 源 4.17.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.1.3.2 ← 源 4.17.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.2.1.2 ← 源 4.17.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0417 派生 4.17.2.2.2 ← 源 4.17.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.17.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.1.5.2 ← 源 4.18.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.1.6.2 ← 源 4.18.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.2.1.2 ← 源 4.18.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0418 派生 4.18.2.2.2 ← 源 4.18.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0419 派生 4.19.2.1.2 ← 源 4.19.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0419 派生 4.19.2.2.2 ← 源 4.19.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.19.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.2.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.3.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.4.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.5.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.1.6.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.2.1.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0420 派生 4.20.2.2.2 ← 源 4.20.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.20.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.1.4.2 ← 源 4.21.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.1.5.2 ← 源 4.21.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.2.1.2 ← 源 4.21.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0421 派生 4.21.2.2.2 ← 源 4.21.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.21.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.1.2.2 ← 源 4.22.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.1.3.2 ← 源 4.22.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.2.1.2 ← 源 4.22.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0422 派生 4.22.2.2.2 ← 源 4.22.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.22.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.2.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.3.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.4.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.1.5.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.2.1.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.2.2.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0423 派生 4.23.2.3.2 ← 源 4.23.1.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.1.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.23.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.1.2.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.1.3.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.1.4.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.1.5.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.2.1.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.2.2.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0424 派生 4.24.2.3.2 ← 源 4.24.1.1.2.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.1.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0425 派生 4.25.1.2.2 ← 源 4.25.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0425 派生 4.25.2.1.2 ← 源 4.25.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0425 派生 4.25.2.2.2 ← 源 4.25.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.25.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0426 派生 4.26.2.1.2 ← 源 4.26.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0426 派生 4.26.2.2.2 ← 源 4.26.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.26.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0427 派生 4.27.1.2.2 ← 源 4.27.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0427 派生 4.27.1.3.2 ← 源 4.27.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0427 派生 4.27.2.1.2 ← 源 4.27.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0427 派生 4.27.2.2.2 ← 源 4.27.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.27.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.1.2.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.1.3.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.1.4.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.1.5.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.2.1.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0428 派生 4.28.2.2.2 ← 源 4.28.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.28.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.1.4.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.1.5.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.2.1.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0429 派生 4.29.2.2.2 ← 源 4.29.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.29.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.1.2.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.1.3.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.1.4.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.2.1.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0430 派生 4.30.2.2.2 ← 源 4.30.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.30.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.1.6.2 ← 源 4.31.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.1.7.2 ← 源 4.31.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.7.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.2.1.2 ← 源 4.31.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0431 派生 4.31.2.2.2 ← 源 4.31.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.31.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.1.2.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.1.4.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.1.5.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.1.6.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.1.7.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.7.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.2.1.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0432 派生 4.32.2.2.2 ← 源 4.32.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.32.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.1.4.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.1.5.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.1.6.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.2.1.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0433 派生 4.33.2.2.2 ← 源 4.33.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.33.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.1.2.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.1.4.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.1.5.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.5.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.1.6.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.6.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.2.1.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0434 派生 4.34.2.2.2 ← 源 4.34.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.34.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.1.3.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.1.4.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.2.1.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0435 派生 4.35.2.2.2 ← 源 4.35.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.35.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.1.3.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.1.4.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.2.1.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0438 派生 4.38.2.2.2 ← 源 4.38.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.38.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.1.2.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.1.3.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.2.1.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0439 派生 4.39.2.2.2 ← 源 4.39.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.39.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.1.2.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.1.3.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0440 派生 4.40.2.1.2 ← 源 4.40.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0441 派生 4.41.2.2.2 ← 源 4.41.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.41.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.1.3.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.1.4.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.4.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.2.1.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0442 派生 4.42.2.2.2 ← 源 4.42.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.42.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0443 派生 4.43.1.3.2 ← 源 4.43.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.43.1.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.2.1.2 ← 源 4.47.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0447 派生 4.47.2.2.2 ← 源 4.47.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.47.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.1.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.2.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0448 派生 4.48.2.3.2 ← 源 4.48.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.48.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.1.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.2.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0449 派生 4.49.2.3.2 ← 源 4.49.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.49.2.3.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.2.1.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0450 派生 4.50.2.2.2 ← 源 4.50.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.50.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.2.1.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0452 派生 4.52.2.2.2 ← 源 4.52.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.52.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0453 派生 4.53.2.1.2 ← 源 4.53.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0453 派生 4.53.2.2.2 ← 源 4.53.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.53.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.2.1.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0454 派生 4.54.2.2.2 ← 源 4.54.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.54.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.2.1.2 ← 源 4.55.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.2.1.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;

    -- 0455 派生 4.55.2.2.2 ← 源 4.55.1.1.2（与注册脚本一致）
    SET v_src = NULL, v_der = NULL;
    SELECT k.ID INTO v_src FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.1.1.2' WHERE k.INVALID = 0 LIMIT 1;
    SELECT k.ID INTO v_der FROM KPI_ITEM k INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.55.2.2.2' WHERE k.INVALID = 0 LIMIT 1;
    IF v_src IS NOT NULL AND v_der IS NOT NULL THEN
        UPDATE KPI_ITEM SET SOURCE_KPI_ID = v_src, COLLECTION_MODE = 'datasource' WHERE ID = v_der AND INVALID = 0;
        CALL sp_kpi_replace_with_source_views(v_der, v_src);
    END IF;


    -- ========== END: 0413～0455 资源消耗注册脚本对齐 ==========

    SELECT '第四章0405-0455分母SOURCE_KPI维护过程已执行（见上方各 IF 块）' AS 检查结果;
END$$

DELIMITER ;

CALL tmp_sync_denominator_source_ch4_0405_0455();
DROP PROCEDURE IF EXISTS `tmp_sync_denominator_source_ch4_0405_0455`;
