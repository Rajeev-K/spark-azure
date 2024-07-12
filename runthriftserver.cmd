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

REM Run thriftserver in docker
REM Note that HADOOP_USER_NAME is set to the username set in Dockerfile
docker run -e SPARK_NO_DAEMONIZE=true -e HADOOP_USER_NAME=sparkuser ^
 -p 10000:10000 -it spark-azure /opt/spark/sbin/start-thriftserver.sh ^
 --conf spark.hadoop.fs.azure.account.key.%AZURE_STORAGE_ACCOUNT_NAME%.dfs.core.windows.net=%AZURE_STORAGE_ACCESS_KEY% ^
 --conf spark.hadoop.fs.azure.account.auth.type.%AZURE_STORAGE_ACCOUNT_NAME%.dfs.core.windows.net=SharedKey ^
 --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=log4j.properties" ^
 --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=log4j.properties" ^
 --master local[*] ^
 --executor-memory 2G ^
 --total-executor-cores 4
