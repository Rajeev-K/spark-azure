@echo off

REM Get the directory of the script
set SCRIPT_DIR=%~dp0

docker run ^
 -v %SCRIPT_DIR%spark-defaults.conf:/opt/spark/conf/spark-defaults.conf ^
 -it spark-azure /opt/spark/bin/spark-sql
