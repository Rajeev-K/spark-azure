@echo off
setlocal

REM Get the directory of the script
set SCRIPT_DIR=%~dp0

REM Make sure spark-defaults.conf has the right settings

docker run -e SPARK_NO_DAEMONIZE=true ^
 -v %SCRIPT_DIR%spark-defaults.conf:/opt/spark/conf/spark-defaults.conf ^
 -p 10000:10000 -it spark-azure /opt/spark/sbin/start-thriftserver.sh
