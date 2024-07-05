@echo off

REM Important: hive-jdbc driver version must be compatible with Spark version
REM Hive JDBC driver for Hive 2.3.9 is compatible with Spark 3.4.0

SET JDBC_DRIVER_VERSION=2.3.9
SET DRIVER_FILE=hive-jdbc-%JDBC_DRIVER_VERSION%-standalone.jar

if exist %DRIVER_FILE% goto run

echo Downloading JDBC driver...
curl https://repo1.maven.org/maven2/org/apache/hive/hive-jdbc/%JDBC_DRIVER_VERSION%/%DRIVER_FILE% --output %DRIVER_FILE%

:run
java.exe -cp .;%DRIVER_FILE% ThriftClient
