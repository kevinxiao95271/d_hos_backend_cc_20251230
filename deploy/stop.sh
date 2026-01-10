#!/bin/bash
# 医院指标管理系统停止脚本

APP_NAME="indicator-management"
PID_FILE="app.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "应用未运行（PID 文件不存在）"
    exit 1
fi

PID=$(cat $PID_FILE)

if ! ps -p $PID > /dev/null 2>&1; then
    echo "应用未运行（进程不存在）"
    rm -f $PID_FILE
    exit 1
fi

echo "正在停止 $APP_NAME (PID: $PID)..."

# 发送 SIGTERM 信号
kill $PID

# 等待进程结束（最多30秒）
for i in {1..30}; do
    if ! ps -p $PID > /dev/null 2>&1; then
        echo "应用已停止"
        rm -f $PID_FILE
        exit 0
    fi
    sleep 1
done

# 如果还没停止，强制杀死
echo "应用未能优雅停止，强制终止..."
kill -9 $PID
rm -f $PID_FILE
echo "应用已强制停止"
