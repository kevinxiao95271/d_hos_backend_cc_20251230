-- 质控考评模块微服务API注册脚本
-- 创建时间: 2024-12-27
-- 版本: 1.0.0

-- 注册微服务API到MS_SERVICE表
INSERT INTO `MS_SERVICE` (
  `SERVICENAME`, 
  `FUNCTIONNAME`, 
  `DESCRIPTION`, 
  `DBOBJECT`, 
  `SYSTEMNAME`, 
  `MODULENAME`, 
  `CREATEUSER`, 
  `CREATEDATE`
) VALUES
-- 考评记录管理API
('查询质控考评记录列表', 'quality_assessment_list', '获取质控考评记录列表，支持分页、关键词搜索、状态筛选、日期范围筛选、部门筛选', 'sp_quality_assessment_list', 'URM-V8', 'quality_assessment', 'system', NOW()),
('获取质控考评记录详情', 'quality_assessment_detail', '获取质控考评记录的详细信息，包括基本信息、细则结果、附件列表', 'sp_quality_assessment_detail', 'URM-V8', 'quality_assessment', 'system', NOW()),
('创建质控考评记录', 'quality_assessment_create', '创建新的质控考评记录，自动初始化考评细则结果', 'sp_quality_assessment_create', 'URM-V8', 'quality_assessment', 'system', NOW()),
('更新质控考评记录', 'quality_assessment_update', '更新质控考评记录的基本信息', 'sp_quality_assessment_update', 'URM-V8', 'quality_assessment', 'system', NOW()),
('删除质控考评记录', 'quality_assessment_delete', '软删除质控考评记录及相关附件', 'sp_quality_assessment_delete', 'URM-V8', 'quality_assessment', 'system', NOW()),
('提交质控考评结果', 'quality_assessment_submit', '提交质控考评结果，更新状态为已完成', 'sp_quality_assessment_submit', 'URM-V8', 'quality_assessment', 'system', NOW()),

-- 考评表模板管理API
('获取质控考评表模板列表', 'quality_assessment_template_list', '获取所有可用的质控考评表模板列表', 'sp_quality_assessment_template_list', 'URM-V8', 'quality_assessment', 'system', NOW()),
('获取质控考评表模板详情', 'quality_assessment_template_detail', '获取指定质控考评表模板的详细信息', 'sp_quality_assessment_template_detail', 'URM-V8', 'quality_assessment', 'system', NOW()),
('获取质控考评表细则项目', 'quality_assessment_template_items', '获取指定质控考评表模板的细则项目列表', 'sp_quality_assessment_template_items', 'URM-V8', 'quality_assessment', 'system', NOW()),

-- 部门管理API
('获取可考评部门列表', 'quality_assessment_dept_list', '获取所有可被考评的部门列表', 'sp_quality_assessment_dept_list', 'URM-V8', 'quality_assessment', 'system', NOW()),

-- 文件管理API
('上传质控考评相关文件', 'quality_assessment_file_upload', '上传质控考评相关的文件，支持关联考评记录和细则结果', 'sp_quality_assessment_file_upload', 'URM-V8', 'quality_assessment', 'system', NOW()),
('获取质控考评相关文件列表', 'quality_assessment_file_list', '获取质控考评相关的文件列表，支持按考评记录和细则结果筛选', 'sp_quality_assessment_file_list', 'URM-V8', 'quality_assessment', 'system', NOW()),
('删除质控考评相关文件', 'quality_assessment_file_delete', '删除质控考评相关的文件记录', 'sp_quality_assessment_file_delete', 'URM-V8', 'quality_assessment', 'system', NOW()),

-- 统计分析API
('获取质控考评统计信息', 'quality_assessment_statistics', '获取质控考评的统计信息，包括部门统计、结果分布、月度趋势等', 'sp_quality_assessment_statistics', 'URM-V8', 'quality_assessment', 'system', NOW())

ON DUPLICATE KEY UPDATE
  `DESCRIPTION` = VALUES(`DESCRIPTION`),
  `DBOBJECT` = VALUES(`DBOBJECT`),
  `MODIFYUSER` = 'system',
  `MODIFYDATE` = NOW();

-- 验证注册结果
SELECT 
  `SERVICENAME`,
  `FUNCTIONNAME`,
  `DBOBJECT`,
  `SYSTEMNAME`,
  `MODULENAME`,
  `CREATEDATE`
FROM `MS_SERVICE` 
WHERE `MODULENAME` = 'quality_assessment' 
  AND `SYSTEMNAME` = 'URM-V8'
ORDER BY `FUNCTIONNAME`;
