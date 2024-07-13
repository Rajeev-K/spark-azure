# Settings to run Spark on Azure

## Setup

Copy `spark-defaults-template.conf` to `spark-defaults.conf` and update it with your Azure Storage account name and access key.

Set environment variable `AZURE_STORAGE_ACCOUNT_NAME` to your storage account name.

## spark-sql

Run `runsparksql.cmd` then try the following SQL, replacing `container` and `storageaccount` with the names of your container and storage account.

```
CREATE TABLE sales
USING csv
OPTIONS (
  path 'abfss://container@storageaccount.dfs.core.windows.net/sales.csv',
  header 'true',
  inferSchema 'true'
);
```

```
select * from sales;
```

## kyuubi

Run `runkyuubi.cmd`.

You can use beeline to run queries:

```
/opt/spark/bin/beeline -u 'jdbc:hive2://172.17.0.2:10009/;user=sparkuser'
```
