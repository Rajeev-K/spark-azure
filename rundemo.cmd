@echo off
setlocal

REM Get the directory of the script
set SCRIPT_DIR=%~dp0

REM Remove trailing backslash if it exists
if "%SCRIPT_DIR:~-1%" == "\" set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Run the pyspark program
docker run ^
 -e AZURE_STORAGE_ACCOUNT_NAME ^
 -e SAS_TOKEN ^
 -v %SCRIPT_DIR%/spark-defaults.conf:/opt/spark/conf/spark-defaults.conf ^
 -it -v %SCRIPT_DIR%:/files spark-azure /opt/spark/bin/spark-submit ^
 /files/demo.py
