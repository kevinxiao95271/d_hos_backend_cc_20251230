-- ============================================================
-- 手工填报子系统 · E2E 测试数据初始化
-- 前提：已执行 report-task-init.sql（建表脚本）
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- 1. 建表（目标库已有则跳过，在测试前先执行 report-task-init.sql）
-- ─────────────────────────────────────────────────────────────

-- ─────────────────────────────────────────────────────────────
-- 2. t_indicator 补 input_type 字段
--    如果已执行 DDL 脚本则跳过此步
-- ─────────────────────────────────────────────────────────────
-- ALTER TABLE t_indicator ADD COLUMN input_type VARCHAR(10) NOT NULL DEFAULT 'AUTO' AFTER metric_code;

-- ─────────────────────────────────────────────────────────────
-- 3. 标记几个指标为手工填报类型（用于自测）
-- ─────────────────────────────────────────────────────────────
-- 取前3个叶子指标改为 MANUAL（你可根据实际 metric_code 修改）
UPDATE t_indicator SET input_type = 'MANUAL'
WHERE is_leaf = 1
  AND status = 1
LIMIT 3;

-- ─────────────────────────────────────────────────────────────
-- 4. 角色数据（确保有管理员和填报人员角色）
-- ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO sys_role (role_id, role_name, role_key, data_scope, status)
VALUES
  (1, '超级管理员', 'admin',   50, 'ACTIVE'),
  (2, '填报人员',   'filler',  10, 'ACTIVE'),
  (3, '只读查看',   'viewer',  20, 'ACTIVE');

-- ─────────────────────────────────────────────────────────────
-- 5. 科室数据（确保有两个测试科室）
-- ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO sys_dept (dept_id, dept_code, dept_name, parent_id, dept_level, status, sort_order)
VALUES
  (101, 'DEPT_INFECT', '感染科',   0, 1, 'ACTIVE', 10),
  (102, 'DEPT_CARD',   '心内科',   0, 1, 'ACTIVE', 20),
  (103, 'DEPT_MGMT',   '质控管理科', 0, 1, 'ACTIVE', 1);

-- ─────────────────────────────────────────────────────────────
-- 6. 测试用户
--    密码统一为 Test1234!（BCrypt 加密，用于验证）
--    密码哈希：$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW
--    （Bcrypt for 'Test1234!'）
-- ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO sys_user (user_id, username, password, real_name, dept_id, role_id, data_scope, status)
VALUES
  (1001, 'admin_test',   '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', '测试管理员', 103, 1, 50, 'ACTIVE'),
  (1002, 'filler_infect','$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', '感染科填报员', 101, 2, 10, 'ACTIVE'),
  (1003, 'filler_card',  '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', '心内科填报员', 102, 2, 10, 'ACTIVE');

-- ─────────────────────────────────────────────────────────────
-- 7. 查询：拿 3 个 MANUAL 指标的 metric_code（填到脚本里）
-- ─────────────────────────────────────────────────────────────
SELECT metric_code, metric_name, input_type
FROM t_indicator
WHERE input_type = 'MANUAL'
LIMIT 5;
