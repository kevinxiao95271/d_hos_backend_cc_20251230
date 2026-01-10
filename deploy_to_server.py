#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
医院指标管理系统 - 自动部署脚本
需要安装: pip install paramiko scp
"""

import os
import sys
import paramiko
from scp import SCPClient

# 设置输出编码
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 服务器配置
SERVER = "81.71.44.180"
USERNAME = "root"
PASSWORD = "Yiguo9527_"
DEPLOY_PATH = "/data/indicator-management"
LOCAL_PATH = "deploy/release"

def create_ssh_client():
    """创建 SSH 客户端"""
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(SERVER, username=USERNAME, password=PASSWORD, timeout=30)
    return client

def print_step(step, total, message):
    """打印步骤信息"""
    print(f"\n[{step}/{total}] {message}")
    print("=" * 60)

def main():
    print("\n" + "=" * 60)
    print("医院指标管理系统 - 自动部署脚本")
    print("=" * 60)

    try:
        # 步骤1: 连接服务器
        print_step(1, 5, "连接服务器...")
        ssh_client = create_ssh_client()
        print(f"✓ 成功连接到 {SERVER}")

        # 步骤2: 创建部署目录
        print_step(2, 5, "创建部署目录...")
        stdin, stdout, stderr = ssh_client.exec_command(f"mkdir -p {DEPLOY_PATH} && echo OK")
        result = stdout.read().decode().strip()
        if result == "OK":
            print(f"✓ 部署目录已创建: {DEPLOY_PATH}")
        else:
            print(f"✗ 创建目录失败: {stderr.read().decode()}")
            sys.exit(1)

        # 步骤3: 停止旧应用
        print_step(3, 5, "停止旧应用...")
        stdin, stdout, stderr = ssh_client.exec_command(f"cd {DEPLOY_PATH} && [ -f stop.sh ] && ./stop.sh || echo '无运行中的应用'")
        print(stdout.read().decode())

        # 步骤4: 上传文件
        print_step(4, 5, "上传部署文件...")
        with SCPClient(ssh_client.get_transport(), progress=progress) as scp:
            for file in os.listdir(LOCAL_PATH):
                local_file = os.path.join(LOCAL_PATH, file)
                if os.path.isfile(local_file):
                    print(f"  上传: {file}")
                    scp.put(local_file, remote_path=DEPLOY_PATH)
        print("✓ 所有文件上传完成")

        # 步骤5: 启动应用
        print_step(5, 5, "启动应用...")
        stdin, stdout, stderr = ssh_client.exec_command(
            f"cd {DEPLOY_PATH} && chmod +x *.sh && ./start.sh"
        )
        print(stdout.read().decode())
        error = stderr.read().decode()
        if error:
            print(f"错误信息: {error}")

        # 查看日志
        print("\n" + "=" * 60)
        print("✓ 部署完成！")
        print("=" * 60)
        print("\n查看应用日志:")
        print(f"  ssh {USERNAME}@{SERVER}")
        print(f"  tail -f {DEPLOY_PATH}/logs/application.log")
        print(f"\n访问应用:")
        print(f"  http://{SERVER}:8080/dgear/swagger-ui.html")
        print()

        # 关闭连接
        ssh_client.close()

    except Exception as e:
        print(f"\n✗ 部署失败: {e}")
        sys.exit(1)

def progress(filename, size, sent):
    """上传进度回调"""
    if sent == size:
        print(f"    ✓ {filename} ({size} bytes)")

if __name__ == "__main__":
    # 检查依赖
    try:
        import paramiko
        from scp import SCPClient
    except ImportError:
        print("缺少依赖库，请运行: pip install paramiko scp")
        sys.exit(1)

    main()
