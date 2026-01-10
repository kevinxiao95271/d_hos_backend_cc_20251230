#!/bin/bash
# 医院指标管理系统启动脚本

APP_NAME="indicator-management"
JAR_FILE="indicator-management-1.0.0-SNAPSHOT.jar"
LOG_DIR="logs"
PID_FILE="app.pid"

# 创建日志目录
mkdir -p $LOG_DIR

# 检查是否已经在运行
if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null 2>&1; then
        echo "应用已在运行中，PID: $PID"
        exit 1
    else
        echo "清理过期的 PID 文件"
        rm -f $PID_FILE
    fi
fi

echo "正在启动 $APP_NAME..."

# 启动应用
nohup java -jar \
    -Xms512m \
    -Xmx1024m \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=$LOG_DIR/heap_dump.hprof \
    -Dfile.encoding=UTF-8 \
    -Duser.timezone=GMT+08 \
    $JAR_FILE \
    > $LOG_DIR/console.log 2>&1 &

# 保存 PID
echo $! > $PID_FILE

echo "应用启动成功，PID: $(cat $PID_FILE)"
echo "日志文件: $LOG_DIR/application.log"
echo "控制台输出: $LOG_DIR/console.log"
echo ""
echo "使用以下命令查看日志："
echo "  tail -f $LOG_DIR/application.log"
echo "  tail -f $LOG_DIR/console.log"
