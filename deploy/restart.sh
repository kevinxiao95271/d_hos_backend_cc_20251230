#!/bin/bash
# 医院指标管理系统重启脚本

echo "正在重启应用..."

# 停止应用
./stop.sh

# 等待2秒
sleep 2

# 启动应用
./start.sh
