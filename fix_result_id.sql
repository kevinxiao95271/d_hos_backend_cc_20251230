-- 修改 t_indicator_result_dept 表,使 result_id 字段允许为 NULL
ALTER TABLE t_indicator_result_dept MODIFY COLUMN result_id BIGINT NULL COMMENT '关联的指标结果ID(可选)';
