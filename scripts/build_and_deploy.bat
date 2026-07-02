@echo off
cd /d "d:\iCode\cursor\d_hos_backend_cc_20251230"
"E:\Tools\mvn\apache-maven-3.9.11\bin\mvn.cmd" clean package -DskipTests -q
if %ERRORLEVEL% NEQ 0 (
    echo BUILD FAILED
    exit /b 1
)
echo BUILD SUCCESS
