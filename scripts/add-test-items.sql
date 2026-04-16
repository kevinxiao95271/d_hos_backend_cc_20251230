-- 临时测试：添加一个查询所有住院记录的指标项

INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, unit, status, sort_order) VALUES
('test_total', '2023年住院总人数（测试）', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate}',
'人', 1, 999),
('test_adult', '2023年成人住院人数（测试）', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND A14 >= 18',
'人', 1, 998),
('test_diagnose', '2023年有主诊断编码的记录（测试）', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND C03C IS NOT NULL AND C03C != ''''',
'人', 1, 997),
('test_sum_days', '2023年总住院天数（测试）', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate}',
'天', 1, 996)
ON DUPLICATE KEY UPDATE query_sql = VALUES(query_sql);
