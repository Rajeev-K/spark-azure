@echo off
setlocal

if "%AZURE_STORAGE_ACCOUNT_NAME%" == "" (
    echo Set STORAGE_ACCOUNT_NAME environment variable to your storage account name.
    exit /b 1
)

if not exist spark-defaults.conf (
    echo Copy spark-defaults-template.conf to spark-defaults.conf and customize it.
    exit /b 1
)

REM Get the directory of the script
set SCRIPT_DIR=%~dp0

REM Remove trailing backslash if it exists
if "%SCRIPT_DIR:~-1%" == "\" set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Run the pyspark program
docker run ^
 -e AZURE_STORAGE_ACCOUNT_NAME ^
 -v %SCRIPT_DIR%/spark-defaults.conf:/opt/spark/conf/spark-defaults.conf ^
 -it -v %SCRIPT_DIR%:/files spark-azure /opt/spark/bin/spark-submit ^
 /files/delta_demo.py
