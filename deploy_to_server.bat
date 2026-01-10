@echo off
echo 正在上传部署文件到服务器...

cd deploy\release

echo.
echo 请在弹出的窗口中输入密码: Yiguo_9527
echo.

scp -o StrictHostKeyChecking=no *.jar *.sh root@81.71.44.180:/opt/indicator-management/

if %errorlevel% == 0 (
    echo.
    echo 文件上传成功！
    echo.
    echo 正在连接服务器启动应用...
    echo.
    ssh root@81.71.44.180 "cd /opt/indicator-management && chmod +x *.sh && ./start.sh"
) else (
    echo.
    echo 文件上传失败！
    pause
)
