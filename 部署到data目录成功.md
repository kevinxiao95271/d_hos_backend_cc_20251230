# 部署成功 - /data 目录

## 📦 部署信息

**部署时间**: 2026-01-10 14:19
**服务器**: 81.71.44.180
**部署目录**: `/data/indicator-management` ✅ 新位置
**应用进程**: PID 8471 ✅ 运行中
**监听端口**: 8080 ✅ 正常

## 📁 目录结构

```
/data/indicator-management/
├── indicator-management-1.0.0-SNAPSHOT.jar  (36MB)
├── start.sh                                  (启动脚本)
├── stop.sh                                   (停止脚本)
├── restart.sh                                (重启脚本)
├── app.pid                                   (进程ID: 8471)
└── logs/                                     (日志目录)
    ├── application.log                       (应用日志 - 按天滚动)
    ├── sql.log                               (SQL日志 - 按天滚动)
    ├── error.log                             (错误日志 - 按天滚动)
    └── console.log                           (控制台输出)
```

## 🎯 日志文件特性

### 按天自动新建日志文件 ✅

```
logs/application-2026-01-10.0.log    # 今天的应用日志
logs/application-2026-01-10.1.log    # 超过100MB后自动分割
logs/application-2026-01-09.0.log    # 昨天的日志
...

logs/sql-2026-01-10.0.log            # 今天的SQL日志
logs/error-2026-01-10.0.log          # 今天的错误日志
```

### 滚动策略

| 日志类型 | 单文件大小 | 保留天数 | 总大小 |
|---------|-----------|---------|--------|
| 应用日志 | 100MB | 30天 | 3GB |
| SQL日志 | 50MB | 7天 | 500MB |
| 错误日志 | 50MB | 30天 | 1GB |

## 🔧 常用命令

### 应用控制

```bash
# 连接服务器
ssh root@81.71.44.180

# 进入部署目录
cd /data/indicator-management

# 停止应用
./stop.sh

# 启动应用
./start.sh

# 重启应用
./restart.sh

# 查看进程状态
ps aux | grep 8471
```

### 查看日志

```bash
# 实时查看应用日志
tail -f /data/indicator-management/logs/application.log

# 实时查看SQL日志
tail -f /data/indicator-management/logs/sql.log

# 实时查看错误日志
tail -f /data/indicator-management/logs/error.log

# 查看今天的日志
cat /data/indicator-management/logs/application-$(date +%Y-%m-%d).*.log

# 查看控制台输出
cat /data/indicator-management/logs/console.log
```

### 查看应用状态

```bash
# 检查进程
ps aux | grep indicator-management | grep -v grep

# 检查端口
netstat -tlnp | grep :8080

# 查看日志文件
ls -lh /data/indicator-management/logs/
```

## 🌐 访问地址

### Swagger API 文档
```
http://81.71.44.180:8080/dgear/swagger-ui.html
```

### Druid 监控
```
http://81.71.44.180:8080/dgear/druid/
用户名: admin
密码: admin
```

### API 示例
```bash
# 查询指标树
curl http://81.71.44.180:8080/dgear/api/indicator/tree

# 查询指标详情
curl http://81.71.44.180:8080/dgear/api/indicator/code/10.3.1
```

## 🔄 重新部署

本地运行部署脚本（已自动更新为 /data 目录）：

```bash
python deploy_to_server.py
```

脚本会自动：
1. 连接服务器 81.71.44.180
2. 停止旧应用
3. 上传文件到 `/data/indicator-management/`
4. 启动新应用
5. 验证运行状态

## 📊 运行状态

```
进程信息:
root  8471  119  3.6  5361232  573708  ?  Sl  14:19  java -jar ...

端口监听:
tcp6  0  0  :::8080  :::*  LISTEN  8471/java

日志文件:
-rw-r--r-- 1 root root  763 Jan 10 14:17 application.log
-rw-r--r-- 1 root root  652 Jan 10 14:19 console.log
-rw-r--r-- 1 root root  375 Jan 10 14:17 error.log
-rw-r--r-- 1 root root    0 Jan 10 14:17 sql.log
```

## ✅ 部署成功确认

- ✅ 应用已部署到 `/data/indicator-management/`
- ✅ 进程正常运行（PID: 8471）
- ✅ 端口 8080 正在监听
- ✅ 日志文件已生成（按天滚动配置已生效）
- ✅ 日志目录结构完整
- ✅ 旧目录 `/opt/indicator-management/` 的应用已停止

## 📝 日志配置说明

详细的日志使用指南请查看：
- [日志配置说明.md](日志配置说明.md)

## ⚠️ 注意事项

1. **旧部署清理**: 如不再需要 `/opt/indicator-management/`，可手动删除：
   ```bash
   rm -rf /opt/indicator-management
   ```

2. **部署脚本更新**: `deploy_to_server.py` 已更新为部署到 `/data` 目录

3. **日志查看**: 所有日志都在 `/data/indicator-management/logs/` 目录下

4. **自动重启**: 如需配置开机自动启动，可创建 systemd 服务或在 rc.local 中添加启动命令

## 🎉 部署完成

服务已成功部署到 `/data/indicator-management/` 目录，日志按天自动滚动，方便问题定位和分析！
