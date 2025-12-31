-- 添加所有指标项到系统
-- 包含：基础指标项、手术相关、单病种质量控制指标项

USE d_hos_claude_0251230;

-- 清空现有测试数据
DELETE FROM t_indicator_item WHERE item_code IN ('test_total', 'test_adult', 'test_diagnose', 'test_sum_days');

-- 插入所有指标项
INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, unit, status, sort_order) VALUES
-- 基础指标项
('total_patients', '总患者数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate}',
'人', 1, 1),

('avg_hospital_days', '平均住院天数', 'COLLECTED', 'D_MR',
'SELECT AVG(B20) AS result_value FROM d_mr WHERE B20 IS NOT NULL AND B15 BETWEEN #{startDate} AND #{endDate}',
'天', 1, 2),

('male_patients', '男性患者数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE (A02 = ''1'' OR A02 = ''男'') AND B15 BETWEEN #{startDate} AND #{endDate}',
'人', 1, 3),

('female_patients', '女性患者数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE (A02 = ''2'' OR A02 = ''女'') AND B15 BETWEEN #{startDate} AND #{endDate}',
'人', 1, 4),

-- 手术相关指标项
('a0027', '手术患者并发症发生例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(DISTINCT d_mr.A48, d_mr.A49) AS result_value FROM d_mr LEFT JOIN D_MR_OTHER_1_20 other ON d_mr.A48 = other.A48 AND d_mr.A49 = other.A49 WHERE d_mr.B15 BETWEEN #{startDate} AND #{endDate} AND ((C14x01C IS NOT NULL OR other.C35x01C IS NOT NULL OR other.C35x02C IS NOT NULL OR other.C35x03C IS NOT NULL OR other.C35x04C IS NOT NULL OR other.C35x05C IS NOT NULL OR other.C35x06C IS NOT NULL OR other.C35x07C IS NOT NULL OR other.C35x08C IS NOT NULL)) AND (C03C NOT LIKE ''O%'' AND C03C NOT LIKE ''P%'' AND C06x01C NOT LIKE ''O%'' AND C06x01C NOT LIKE ''P%'') AND ((C03C LIKE ''T81.0%'' OR C03C LIKE ''T81.1%'' OR C03C LIKE ''T81.3%'' OR C03C LIKE ''T81.7%'' OR C03C LIKE ''T81.8%'' OR C03C LIKE ''T81.9%'' OR C03C LIKE ''A40%'' OR C03C LIKE ''A410%'' OR C03C LIKE ''I26.9%'' OR C03C LIKE ''R96%'' OR C03C LIKE ''J96%'' OR C03C LIKE ''E86%'' OR C03C LIKE ''I80.205%'' OR C03C LIKE ''I80.206%'' OR C03C LIKE ''I80.207%'' OR C06x01C LIKE ''T81.0%'' OR C06x01C LIKE ''T81.1%'' OR C06x01C LIKE ''T81.3%'' OR C06x01C LIKE ''T81.7%'' OR C06x01C LIKE ''T81.8%'' OR C06x01C LIKE ''T81.9%'' OR C06x01C LIKE ''A40%'' OR C06x01C LIKE ''A410%'' OR C06x01C LIKE ''I26.9%'' OR C06x01C LIKE ''R96%'' OR C06x01C LIKE ''J96%'' OR C06x01C LIKE ''E86%'' OR C06x01C LIKE ''I80.205%'' OR C06x01C LIKE ''I80.206%'' OR C06x01C LIKE ''I80.207%''))',
'人', 1, 10),

('a0329', '同期出院的手术患者人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(DISTINCT d_mr.A48, d_mr.A49) AS result_value FROM d_mr LEFT JOIN D_MR_OTHER_1_20 other ON d_mr.A48 = other.A48 AND d_mr.A49 = other.A49 WHERE d_mr.B15 BETWEEN #{startDate} AND #{endDate} AND ((C14x01C IS NOT NULL OR other.C35x01C IS NOT NULL OR other.C35x02C IS NOT NULL OR other.C35x03C IS NOT NULL OR other.C35x04C IS NOT NULL OR other.C35x05C IS NOT NULL OR other.C35x06C IS NOT NULL OR other.C35x07C IS NOT NULL OR other.C35x08C IS NOT NULL)) AND (C03C NOT LIKE ''O%'' AND C03C NOT LIKE ''P%'' AND C06x01C NOT LIKE ''O%'' AND C06x01C NOT LIKE ''P%'')',
'人', 1, 11),

('a0029', 'I类切口手术部位感染人次数', 'COLLECTED', 'D_MR',
'SELECT COUNT(DISTINCT d_mr.A48, d_mr.A49) AS result_value FROM d_mr LEFT JOIN D_MR_OTHER_1_20 other ON d_mr.A48 = other.A48 AND d_mr.A49 = other.A49 WHERE d_mr.B15 BETWEEN #{startDate} AND #{endDate} AND (C21x01C = ''3'' OR other.C42x01C = ''3'' OR other.C42x02C = ''3'' OR other.C42x03C = ''3'' OR other.C42x04C = ''3'' OR other.C42x05C = ''3'' OR other.C42x06C = ''3'' OR other.C42x07C = ''3'' OR other.C42x08C = ''3'')',
'人次', 1, 12),

('a0030', '同期I类切口手术台次数', 'COLLECTED', 'D_MR',
'SELECT COUNT(DISTINCT d_mr.A48, d_mr.A49) AS result_value FROM d_mr LEFT JOIN D_MR_OTHER_1_20 other ON d_mr.A48 = other.A48 AND d_mr.A49 = other.A49 WHERE d_mr.B15 BETWEEN #{startDate} AND #{endDate} AND (C21x01C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x01C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x02C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x03C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x04C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x05C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x06C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x07C IN (''1'', ''2'', ''3'', ''10'') OR other.C42x08C IN (''1'', ''2'', ''3'', ''10''))',
'台次', 1, 13),

-- 急性心肌梗死相关指标项
('a0032', '急性心肌梗死病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I21%'' OR C06x01C LIKE ''I21%'')',
'人', 1, 20),

('a0034', '急性心肌梗死出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I21%'' OR C06x01C LIKE ''I21%'')',
'床日', 1, 21),

('a0037', '急性心肌梗死总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I21%'' OR C06x01C LIKE ''I21%'')',
'元', 1, 22),

('a0040', '急性心肌梗死死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I21%'' OR C06x01C LIKE ''I21%'') AND B34C = ''5''',
'人', 1, 23),

-- 心力衰竭相关指标项
('a0041', '心力衰竭病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I11.0%'' OR C03C LIKE ''I13.0%'' OR C03C LIKE ''I13.2%'' OR C03C = ''I50'' OR C06x01C LIKE ''I11.0%'' OR C06x01C LIKE ''I13.0%'' OR C06x01C LIKE ''I13.2%'' OR C06x01C = ''I50'')',
'人', 1, 30),

('a0043', '心力衰竭出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I11.0%'' OR C03C LIKE ''I13.0%'' OR C03C LIKE ''I13.2%'' OR C03C = ''I50'' OR C06x01C LIKE ''I11.0%'' OR C06x01C LIKE ''I13.0%'' OR C06x01C LIKE ''I13.2%'' OR C06x01C = ''I50'')',
'床日', 1, 31),

('a0046', '心力衰竭总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I11.0%'' OR C03C LIKE ''I13.0%'' OR C03C LIKE ''I13.2%'' OR C03C = ''I50'' OR C06x01C LIKE ''I11.0%'' OR C06x01C LIKE ''I13.0%'' OR C06x01C LIKE ''I13.2%'' OR C06x01C = ''I50'')',
'元', 1, 32),

('a0049', '心力衰竭死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I11.0%'' OR C03C LIKE ''I13.0%'' OR C03C LIKE ''I13.2%'' OR C03C = ''I50'' OR C06x01C LIKE ''I11.0%'' OR C06x01C LIKE ''I13.0%'' OR C06x01C LIKE ''I13.2%'' OR C06x01C = ''I50'') AND B34C = ''5''',
'人', 1, 33),

-- 肺炎（住院、成人）相关指标项
('a0050', '肺炎（住院、成人）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 >= 18',
'人', 1, 40),

('a0052', '肺炎（住院、成人）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 >= 18',
'床日', 1, 41),

('a0055', '肺炎（住院、成人）总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 >= 18',
'元', 1, 42),

('a0058', '肺炎（住院、成人）死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 >= 18 AND B34C = ''5''',
'人', 1, 43),

-- 肺炎（住院、儿童）相关指标项
('a0059', '肺炎（住院、儿童）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(DISTINCT A48, A49) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 < 18 AND A14 > 1',
'人', 1, 50),

('a0061', '肺炎（住院、儿童）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 < 18 AND A14 > 1',
'床日', 1, 51),

('a0064', '肺炎（住院、儿童）总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 < 18 AND A14 > 1',
'元', 1, 52),

('a0067', '肺炎（住院、儿童）死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C = ''J18'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C = ''J18'') AND A14 < 18 AND A14 > 1 AND B34C = ''5''',
'人', 1, 53),

-- 脑梗死相关指标项
('a0068', '脑梗死病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I63%'' OR C06x01C LIKE ''I63%'') AND C03C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'') AND C06x01C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'')',
'人', 1, 60),

('a0070', '脑梗死出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I63%'' OR C06x01C LIKE ''I63%'') AND C03C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'') AND C06x01C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'')',
'床日', 1, 61),

('a0073', '脑梗死总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I63%'' OR C06x01C LIKE ''I63%'') AND C03C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'') AND C06x01C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'')',
'元', 1, 62),

('a0076', '脑梗死死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''I63%'' OR C06x01C LIKE ''I63%'') AND C03C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'') AND C06x01C NOT IN (''I63.301'', ''I63.302'', ''I63.401'', ''I63.801'', ''I63.802'') AND B34C = ''5''',
'人', 1, 63),

-- 髋关节置换术相关指标项
('a0077', '髋关节置换术病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.51%'' OR C03C LIKE ''81.52%'' OR C06x01C LIKE ''81.51%'' OR C06x01C LIKE ''81.52%'')',
'人', 1, 70),

('a0079', '髋关节置换术出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.51%'' OR C03C LIKE ''81.52%'' OR C06x01C LIKE ''81.51%'' OR C06x01C LIKE ''81.52%'')',
'床日', 1, 71),

('a0082', '髋关节置换术总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.51%'' OR C03C LIKE ''81.52%'' OR C06x01C LIKE ''81.51%'' OR C06x01C LIKE ''81.52%'')',
'元', 1, 72),

('a0085', '髋关节置换术死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.51%'' OR C03C LIKE ''81.52%'' OR C06x01C LIKE ''81.51%'' OR C06x01C LIKE ''81.52%'') AND B34C = ''5''',
'人', 1, 73),

-- 膝关节置换术相关指标项
('a0086', '膝关节置换术病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.54%'' OR C06x01C LIKE ''81.54%'')',
'人', 1, 80),

('a0088', '膝关节置换术出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.54%'' OR C06x01C LIKE ''81.54%'')',
'床日', 1, 81),

('a0091', '膝关节置换术总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.54%'' OR C06x01C LIKE ''81.54%'')',
'元', 1, 82),

('a0094', '膝关节置换术死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''81.54%'' OR C06x01C LIKE ''81.54%'') AND B34C = ''5''',
'人', 1, 83),

-- 冠状动脉旁路移植术相关指标项
('a0095', '冠状动脉旁路移植术病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''36.1%'' OR C06x01C LIKE ''36.1%'')',
'人', 1, 90),

('a0097', '冠状动脉旁路移植术出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''36.1%'' OR C06x01C LIKE ''36.1%'')',
'床日', 1, 91),

('a0100', '冠状动脉旁路移植术总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''36.1%'' OR C06x01C LIKE ''36.1%'')',
'元', 1, 92),

('a0103', '冠状动脉旁路移植术死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''36.1%'' OR C06x01C LIKE ''36.1%'') AND B34C = ''5''',
'人', 1, 93),

-- 剖宫产相关指标项
('a0104', '剖宫产病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''74.0%'' OR C03C LIKE ''74.1%'' OR C03C LIKE ''74.2%'')',
'人', 1, 100),

('a0106', '剖宫产出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''74.0%'' OR C03C LIKE ''74.1%'' OR C03C LIKE ''74.2%'')',
'床日', 1, 101),

('a0109', '剖宫产总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''74.0%'' OR C03C LIKE ''74.1%'' OR C03C LIKE ''74.2%'')',
'元', 1, 102),

('a0112', '剖宫产死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''74.0%'' OR C03C LIKE ''74.1%'' OR C03C LIKE ''74.2%'') AND B34C = ''5''',
'人', 1, 103),

-- 慢性阻塞性肺疾病相关指标项
('a0113', '慢性阻塞性肺疾病病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J44.0%'' OR C03C LIKE ''J44.1%'' OR C03C LIKE ''J44.9%'' OR C06x01C LIKE ''J44.0%'' OR C06x01C LIKE ''J44.1%'' OR C06x01C LIKE ''J44.9%'')',
'人', 1, 110),

('a0115', '慢性阻塞性肺疾病出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J44.0%'' OR C03C LIKE ''J44.1%'' OR C03C LIKE ''J44.9%'' OR C06x01C LIKE ''J44.0%'' OR C06x01C LIKE ''J44.1%'' OR C06x01C LIKE ''J44.9%'')',
'床日', 1, 111),

('a0118', '慢性阻塞性肺疾病总出院费用', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(D01), 0) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J44.0%'' OR C03C LIKE ''J44.1%'' OR C03C LIKE ''J44.9%'' OR C06x01C LIKE ''J44.0%'' OR C06x01C LIKE ''J44.1%'' OR C06x01C LIKE ''J44.9%'')',
'元', 1, 112),

('a0121', '慢性阻塞性肺疾病死亡人数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) AS result_value FROM d_mr WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J44.0%'' OR C03C LIKE ''J44.1%'' OR C03C LIKE ''J44.9%'' OR C06x01C LIKE ''J44.0%'' OR C06x01C LIKE ''J44.1%'' OR C06x01C LIKE ''J44.9%'') AND B34C = ''5''',
'人', 1, 113)

ON DUPLICATE KEY UPDATE
    item_name = VALUES(item_name),
    query_sql = VALUES(query_sql),
    unit = VALUES(unit),
    sort_order = VALUES(sort_order);

SELECT '指标项插入完成！' as status, COUNT(*) as total_count FROM t_indicator_item;
