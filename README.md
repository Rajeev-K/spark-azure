# Settings to run Spark on Azure

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

Prepare `spark-defaults.conf` and update it with the right Azure Storage account name and access key, then run `runkyuubi.cmd`.

You can use beeline to run queries:

```
/opt/spark/bin/beeline -u 'jdbc:hive2://172.17.0.2:10009/;user=sparkuser'
```
