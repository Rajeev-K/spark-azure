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

REM Run spark-sql in docker
docker run -it spark-azure /opt/spark/bin/spark-sql ^
 --jars /opt/spark/jars/hadoop-azure-3.2.0.jar,/opt/spark/jars/azure-storage-blob-12.10.2.jar,/opt/spark/jars/wildfly-openssl-2.2.5.jar ^
 --conf spark.hadoop.fs.azure.account.key.%AZURE_STORAGE_ACCOUNT_NAME%.dfs.core.windows.net=%AZURE_STORAGE_ACCESS_KEY% ^
 --conf spark.hadoop.fs.azure.account.auth.type.%AZURE_STORAGE_ACCOUNT_NAME%.dfs.core.windows.net=SharedKey
