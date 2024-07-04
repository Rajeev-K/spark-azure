@echo off
setlocal

REM Check if the required environment variables are set
if "%AZURE_STORAGE_ACCESS_KEY%"=="" (
    echo ERROR: AZURE_STORAGE_ACCESS_KEY environment variable is not set.
    exit /b 1
)
if "%AZURE_STORAGE_ACCOUNT_NAME%"=="" (
    echo ERROR: AZURE_STORAGE_ACCOUNT_NAME environment variable is not set.
    exit /b 1
)

REM Get the directory of the script
set SCRIPT_DIR=%~dp0

REM Remove trailing backslash if it exists
if "%SCRIPT_DIR:~-1%" == "\" set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Run the pyspark program
docker run -e AZURE_STORAGE_ACCESS_KEY -e AZURE_STORAGE_ACCOUNT_NAME ^
-it -v %SCRIPT_DIR%:/files spark-azure /opt/spark/bin/spark-submit ^
--conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=log4j.properties" ^
--conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=log4j.properties" ^
/files/demo.py
