-- 系统全局配置表
CREATE TABLE IF NOT EXISTS t_system_config (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    config_key  VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT        COMMENT '配置值',
    config_desc VARCHAR(200) COMMENT '配置说明',
    update_by   VARCHAR(50)  COMMENT '最后修改人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_config_key (config_key)
) COMMENT='系统全局配置';

-- 初始配置
INSERT INTO t_system_config (config_key, config_value, config_desc) VALUES
('hospital_name',   '医院名称',             '医院机构名称，用于报告封面及正文'),
('hospital_level',  '三级中医医院',          '医院等级，用于报告前言'),
('report_title',    '绩效指标达标情况和监测报告', '报告默认标题')
ON DUPLICATE KEY UPDATE config_desc = VALUES(config_desc);

-- 为 t_indicator 添加目标值和监测方向字段（幂等执行）
ALTER TABLE t_indicator
    ADD COLUMN IF NOT EXISTS target_value      DECIMAL(20,4) DEFAULT NULL COMMENT '目标值',
    ADD COLUMN IF NOT EXISTS monitor_direction VARCHAR(20)   DEFAULT NULL
        COMMENT '监测方向：INCREASE(逐步提高) / DECREASE(逐步降低) / MONITOR(监测比较)';
