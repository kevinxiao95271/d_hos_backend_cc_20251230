import sys, pymysql
sys.stdout.reconfigure(encoding='utf-8')

conn = pymysql.connect(
    host='gz-cdb-bq7gk3k5.sql.tencentcdb.com',
    port=63606,
    user='root',
    password='Yiguo9527_',
    database='d_hos_claude_0251230',
    charset='utf8mb4'
)

def q(sql, title=''):
    if title:
        print(f'\n=== {title} ===')
    cur = conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()
    cols = [d[0] for d in cur.description]
    print('\t'.join(cols))
    for row in rows:
        print('\t'.join(str(v) if v is not None else 'NULL' for v in row))
    cur.close()
    return rows

q("SHOW TABLES", "所有表")
q("SELECT COUNT(*) cnt FROM t_indicator", "t_indicator 总数")
q("SELECT metric_code,metric_name,is_leaf,status,calculation_type FROM t_indicator LIMIT 20", "t_indicator 前20条")
q("SELECT metric_code,metric_name,is_leaf,calculation_type,related_items FROM t_indicator WHERE is_leaf=1 LIMIT 10", "叶子指标(is_leaf=1)")
q("SELECT metric_code,metric_name,is_leaf,parent_code FROM t_indicator WHERE metric_code='GRP_SURGERY'", "GRP_SURGERY详情")
q("SELECT metric_code,metric_name,is_leaf FROM t_indicator WHERE parent_code='GRP_SURGERY'", "GRP_SURGERY子指标")
q("SELECT item_code,item_name,item_type,status FROM t_indicator_item LIMIT 10", "t_indicator_item 前10")
q("SELECT metric_code,time_value,result_value FROM t_indicator_result ORDER BY create_time DESC LIMIT 10", "最近计算结果")

conn.close()
