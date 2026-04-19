-- 质控考评模块数据库表结构初始化脚本
-- 创建时间: 2024-12-27
-- 版本: 1.0.0

-- 1. 考评表模板表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `TEMPLATE_CODE` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码',
  `TEMPLATE_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `DESCRIPTION` text COLLATE utf8mb4_unicode_ci COMMENT '模板描述',
  `TOTAL_SCORE` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT '总分',
  `PASS_SCORE` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT '及格分',
  `ITEM_COUNT` int NOT NULL DEFAULT 0 COMMENT '细则项目数量',
  `STATUS` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `CREATE_USER` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_USER` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `UPDATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `INVALID` tinyint DEFAULT 0 COMMENT '是否无效：0-有效，1-无效',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_TEMPLATE_CODE` (`TEMPLATE_CODE`),
  KEY `IDX_TEMPLATE_STATUS` (`STATUS`),
  KEY `IDX_TEMPLATE_CREATE_TIME` (`CREATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质控考评表模板';

-- 2. 考评表模板细则表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '细则ID',
  `TEMPLATE_ID` int NOT NULL COMMENT '模板ID',
  `ITEM_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '细则名称',
  `DESCRIPTION` text COLLATE utf8mb4_unicode_ci COMMENT '细则描述',
  `MAX_SCORE` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT '最大分值',
  `SORT_ORDER` int NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `ITEM_TYPE` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'standard' COMMENT '细则类型：standard-标准，bonus-加分，penalty-扣分',
  `REQUIRED` tinyint NOT NULL DEFAULT 1 COMMENT '是否必填：1-必填，0-可选',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`ID`),
  KEY `IDX_TEMPLATE_ID` (`TEMPLATE_ID`),
  KEY `IDX_SORT_ORDER` (`SORT_ORDER`),
  CONSTRAINT `FK_TEMPLATE_ITEM_TEMPLATE` FOREIGN KEY (`TEMPLATE_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考评表模板细则';

-- 3. 考评记录表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_RECORD` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '考评记录ID',
  `ASSESSMENT_CODE` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '考评编号',
  `TEMPLATE_ID` int NOT NULL COMMENT '考评表模板ID',
  `ASSESSMENT_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '考评名称',
  `ASSESSMENT_DATE` date NOT NULL COMMENT '考评日期',
  `ASSESSMENT_TYPE` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'regular' COMMENT '考评类型：regular-定期考评，special-专项考评',
  `ASSESSMENT_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'draft' COMMENT '考评状态：draft-草稿，in_progress-进行中，completed-已完成，archived-已归档',
  `ASSESSOR` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '考评人员',
  `ASSESSMENT_DEPT` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '考评部门',
  `TOTAL_SCORE` decimal(8,2) DEFAULT 0.00 COMMENT '实际得分',
  `MAX_SCORE` decimal(8,2) DEFAULT 0.00 COMMENT '最高分值',
  `PASS_SCORE` decimal(8,2) DEFAULT 0.00 COMMENT '及格分值',
  `ASSESSMENT_RESULT` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '考评结果：excellent-优秀，good-良好，qualified-合格，unqualified-不合格',
  `REMARKS` text COLLATE utf8mb4_unicode_ci COMMENT '考评备注',
  `CREATE_USER` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_USER` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `UPDATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `INVALID` tinyint DEFAULT 0 COMMENT '是否无效：0-有效，1-无效',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ASSESSMENT_CODE` (`ASSESSMENT_CODE`),
  KEY `IDX_TEMPLATE_ID` (`TEMPLATE_ID`),
  KEY `IDX_ASSESSMENT_DATE` (`ASSESSMENT_DATE`),
  KEY `IDX_ASSESSMENT_STATUS` (`ASSESSMENT_STATUS`),
  KEY `IDX_ASSESSMENT_DEPT` (`ASSESSMENT_DEPT`),
  CONSTRAINT `FK_ASSESSMENT_RECORD_TEMPLATE` FOREIGN KEY (`TEMPLATE_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质控考评记录';

-- 4. 考评细则结果表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_ITEM_RESULT` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '结果ID',
  `ASSESSMENT_ID` int NOT NULL COMMENT '考评记录ID',
  `TEMPLATE_ITEM_ID` int NOT NULL COMMENT '模板细则ID',
  `IS_QUALIFIED` tinyint DEFAULT NULL COMMENT '是否合格：1-合格，0-不合格',
  `ACTUAL_SCORE` decimal(8,2) DEFAULT 0.00 COMMENT '实际得分',
  `EVALUATION_REMARK` text COLLATE utf8mb4_unicode_ci COMMENT '评价说明',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ASSESSMENT_ITEM` (`ASSESSMENT_ID`, `TEMPLATE_ITEM_ID`),
  KEY `IDX_ASSESSMENT_ID` (`ASSESSMENT_ID`),
  KEY `IDX_TEMPLATE_ITEM_ID` (`TEMPLATE_ITEM_ID`),
  CONSTRAINT `FK_ITEM_RESULT_ASSESSMENT` FOREIGN KEY (`ASSESSMENT_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_RECORD` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `FK_ITEM_RESULT_TEMPLATE_ITEM` FOREIGN KEY (`TEMPLATE_ITEM_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考评细则结果';

-- 5. 考评附件表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '附件ID',
  `ASSESSMENT_ID` int NOT NULL COMMENT '考评记录ID',
  `ITEM_RESULT_ID` int DEFAULT NULL COMMENT '细则结果ID（可选，关联具体细则）',
  `FILE_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名',
  `FILE_PATH` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `FILE_SIZE` bigint DEFAULT 0 COMMENT '文件大小（字节）',
  `FILE_TYPE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `UPLOAD_USER` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传用户',
  `UPLOAD_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `INVALID` tinyint DEFAULT 0 COMMENT '是否无效：0-有效，1-无效',
  PRIMARY KEY (`ID`),
  KEY `IDX_ASSESSMENT_ID` (`ASSESSMENT_ID`),
  KEY `IDX_ITEM_RESULT_ID` (`ITEM_RESULT_ID`),
  KEY `IDX_UPLOAD_TIME` (`UPLOAD_TIME`),
  CONSTRAINT `FK_ATTACHMENT_ASSESSMENT` FOREIGN KEY (`ASSESSMENT_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_RECORD` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `FK_ATTACHMENT_ITEM_RESULT` FOREIGN KEY (`ITEM_RESULT_ID`) REFERENCES `MEDICAL_QUALITY_ASSESSMENT_ITEM_RESULT` (`ID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考评附件';

-- 6. 考评部门权限表
CREATE TABLE IF NOT EXISTS `MEDICAL_QUALITY_ASSESSMENT_DEPT_PERMISSION` (
  `ID` int NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `DEPT_ID` int NOT NULL COMMENT '部门ID',
  `DEPT_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部门名称',
  `DEPT_CODE` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '部门编码',
  `CAN_ASSESS` tinyint NOT NULL DEFAULT 1 COMMENT '是否可被考评：1-可考评，0-不可考评',
  `ASSESSMENT_LEVEL` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'standard' COMMENT '考评级别：standard-标准，high-高要求，low-低要求',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`ID`),
  KEY `IDX_DEPT_ID` (`DEPT_ID`),
  KEY `IDX_CAN_ASSESS` (`CAN_ASSESS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考评部门权限';

-- 7. 考评统计视图
CREATE OR REPLACE VIEW `V_MEDICAL_QUALITY_ASSESSMENT_STATS` AS
SELECT 
  a.ASSESSMENT_DEPT,
  COUNT(a.ID) as total_assessments,
  SUM(CASE WHEN a.ASSESSMENT_STATUS = 'completed' THEN 1 ELSE 0 END) as completed_assessments,
  SUM(CASE WHEN a.ASSESSMENT_STATUS = 'draft' THEN 1 ELSE 0 END) as draft_assessments,
  SUM(CASE WHEN a.ASSESSMENT_STATUS = 'in_progress' THEN 1 ELSE 0 END) as in_progress_assessments,
  AVG(a.TOTAL_SCORE) as avg_score,
  AVG(CASE WHEN a.MAX_SCORE > 0 THEN (a.TOTAL_SCORE / a.MAX_SCORE) * 100 ELSE 0 END) as avg_score_percentage,
  COUNT(CASE WHEN a.ASSESSMENT_RESULT = 'excellent' THEN 1 END) as excellent_count,
  COUNT(CASE WHEN a.ASSESSMENT_RESULT = 'good' THEN 1 END) as good_count,
  COUNT(CASE WHEN a.ASSESSMENT_RESULT = 'qualified' THEN 1 END) as qualified_count,
  COUNT(CASE WHEN a.ASSESSMENT_RESULT = 'unqualified' THEN 1 END) as unqualified_count
FROM MEDICAL_QUALITY_ASSESSMENT_RECORD a
WHERE a.INVALID = 0
GROUP BY a.ASSESSMENT_DEPT;

-- 8. 插入初始数据
INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` (
  `TEMPLATE_CODE`, 
  `TEMPLATE_NAME`, 
  `DESCRIPTION`, 
  `TOTAL_SCORE`, 
  `PASS_SCORE`, 
  `ITEM_COUNT`, 
  `STATUS`, 
  `CREATE_USER`
) VALUES
('TEMPLATE_001', '医疗质量基础考评表', '适用于医疗质量基础考评，包含医疗安全、服务质量、管理规范等基础项目', 100.00, 80.00, 20, 1, 'system'),
('TEMPLATE_002', '护理质量专项考评表', '适用于护理质量专项考评，重点关注护理操作规范、患者安全、护理记录等', 100.00, 85.00, 25, 1, 'system'),
('TEMPLATE_003', '医技科室质量考评表', '适用于医技科室质量考评，包括检验、影像、病理等科室的质量管理', 100.00, 80.00, 18, 1, 'system')
ON DUPLICATE KEY UPDATE
  `TEMPLATE_NAME` = VALUES(`TEMPLATE_NAME`),
  `DESCRIPTION` = VALUES(`DESCRIPTION`),
  `TOTAL_SCORE` = VALUES(`TOTAL_SCORE`),
  `PASS_SCORE` = VALUES(`PASS_SCORE`),
  `UPDATE_TIME` = NOW();

-- 9. 插入模板细则示例数据
INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM` (
  `TEMPLATE_ID`, 
  `ITEM_NAME`, 
  `DESCRIPTION`, 
  `MAX_SCORE`, 
  `SORT_ORDER`, 
  `ITEM_TYPE`, 
  `REQUIRED`
) VALUES
-- 模板1的细则
(1, '医疗安全管理制度', '检查医疗安全管理制度是否健全，是否定期更新', 5.00, 1, 'standard', 1),
(1, '医疗设备管理', '检查医疗设备是否定期维护，是否建立设备档案', 5.00, 2, 'standard', 1),
(1, '医疗文书质量', '检查医疗文书书写是否规范，是否及时完成', 10.00, 3, 'standard', 1),
(1, '患者安全管理', '检查患者安全措施是否到位，是否建立应急预案', 10.00, 4, 'standard', 1),
(1, '感染控制', '检查感染控制措施是否落实，消毒隔离是否规范', 10.00, 5, 'standard', 1),
(1, '药品管理', '检查药品管理是否规范，是否建立药品不良反应报告制度', 8.00, 6, 'standard', 1),
(1, '医疗废物管理', '检查医疗废物分类收集、转运是否规范', 5.00, 7, 'standard', 1),
(1, '人员培训', '检查人员培训是否定期开展，培训记录是否完整', 5.00, 8, 'standard', 1),
(1, '质量改进', '检查是否建立质量改进机制，是否定期分析质量问题', 8.00, 9, 'standard', 1),
(1, '患者满意度', '检查患者满意度调查是否开展，满意度是否达标', 10.00, 10, 'standard', 1),
(1, '医疗纠纷处理', '检查医疗纠纷处理机制是否健全，处理是否及时', 8.00, 11, 'standard', 1),
(1, '信息安全管理', '检查患者信息安全保护措施是否到位', 6.00, 12, 'standard', 1),
(1, '应急管理', '检查应急预案是否完善，应急演练是否定期开展', 8.00, 13, 'standard', 1),
(1, '科研教学', '检查科研教学工作开展情况，是否取得成果', 6.00, 14, 'standard', 1),
(1, '成本控制', '检查成本控制措施是否有效，资源利用是否合理', 4.00, 15, 'standard', 1),
(1, '团队协作', '检查科室内部协作是否良好，跨科室协作是否顺畅', 4.00, 16, 'standard', 1),
(1, '创新管理', '检查是否有管理创新举措，是否取得良好效果', 4.00, 17, 'standard', 1),
(1, '文化建设', '检查科室文化建设情况，是否形成良好氛围', 3.00, 18, 'standard', 1),
(1, '社会责任', '检查是否承担社会责任，是否参与公益活动', 2.00, 19, 'standard', 1),
(1, '持续改进', '检查是否建立持续改进机制，改进效果是否明显', 3.00, 20, 'standard', 1)
ON DUPLICATE KEY UPDATE
  `ITEM_NAME` = VALUES(`ITEM_NAME`),
  `DESCRIPTION` = VALUES(`DESCRIPTION`),
  `MAX_SCORE` = VALUES(`MAX_SCORE`),
  `UPDATE_TIME` = NOW();

-- 10. 插入部门权限示例数据
INSERT INTO `MEDICAL_QUALITY_ASSESSMENT_DEPT_PERMISSION` (
  `DEPT_ID`, 
  `DEPT_NAME`, 
  `DEPT_CODE`, 
  `CAN_ASSESS`, 
  `ASSESSMENT_LEVEL`
) VALUES
(1, '内科', 'NEIKE', 1, 'standard'),
(2, '外科', 'WAIKE', 1, 'standard'),
(3, '妇产科', 'FUCHANKE', 1, 'high'),
(4, '儿科', 'ERKE', 1, 'high'),
(5, '急诊科', 'JIZHENKE', 1, 'high'),
(6, '重症医学科', 'ZHONGZHENG', 1, 'high'),
(7, '检验科', 'JIANYANKE', 1, 'standard'),
(8, '影像科', 'YINGXIANGKE', 1, 'standard'),
(9, '病理科', 'BINGLIKE', 1, 'standard'),
(10, '药剂科', 'YAOJIK', 1, 'standard'),
(11, '护理部', 'HULIBU', 1, 'high'),
(12, '医务科', 'YIWUKE', 1, 'standard'),
(13, '质控科', 'ZHIKONGKE', 1, 'standard'),
(14, '院感科', 'YUANGANKE', 1, 'high'),
(15, '信息科', 'XINXIK', 1, 'standard')
ON DUPLICATE KEY UPDATE
  `DEPT_NAME` = VALUES(`DEPT_NAME`),
  `DEPT_CODE` = VALUES(`DEPT_CODE`),
  `CAN_ASSESS` = VALUES(`CAN_ASSESS`),
  `ASSESSMENT_LEVEL` = VALUES(`ASSESSMENT_LEVEL`),
  `UPDATE_TIME` = NOW();

-- 11. 更新模板的细则数量
UPDATE `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` 
SET `ITEM_COUNT` = (
  SELECT COUNT(*) FROM `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE_ITEM` 
  WHERE `TEMPLATE_ID` = `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE`.`ID`
);

-- 12. 创建索引优化查询性能
CREATE INDEX IF NOT EXISTS `IDX_ASSESSMENT_TEMPLATE_STATUS_CREATE_TIME` ON `MEDICAL_QUALITY_ASSESSMENT_TEMPLATE` (`STATUS`, `CREATE_TIME`);
CREATE INDEX IF NOT EXISTS `IDX_ASSESSMENT_RECORD_STATUS_DATE` ON `MEDICAL_QUALITY_ASSESSMENT_RECORD` (`ASSESSMENT_STATUS`, `ASSESSMENT_DATE`);
CREATE INDEX IF NOT EXISTS `IDX_ASSESSMENT_RECORD_DEPT_STATUS` ON `MEDICAL_QUALITY_ASSESSMENT_RECORD` (`ASSESSMENT_DEPT`, `ASSESSMENT_STATUS`);
CREATE INDEX IF NOT EXISTS `IDX_ITEM_RESULT_ASSESSMENT_ITEM` ON `MEDICAL_QUALITY_ASSESSMENT_ITEM_RESULT` (`ASSESSMENT_ID`, `TEMPLATE_ITEM_ID`);
CREATE INDEX IF NOT EXISTS `IDX_ATTACHMENT_ASSESSMENT_TIME` ON `MEDICAL_QUALITY_ASSESSMENT_ATTACHMENT` (`ASSESSMENT_ID`, `UPLOAD_TIME`);

-- 13. 插入初始化完成记录
INSERT INTO `sys_module_init_log` (`module_name`, `version`, `init_time`, `status`, `message`) VALUES
('quality_assessment', '1.0.0', NOW(), 'success', '质控考评模块数据库初始化完成')
ON DUPLICATE KEY UPDATE
  `init_time` = NOW(),
  `status` = 'success',
  `message` = '质控考评模块数据库初始化完成';
