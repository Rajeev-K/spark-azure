# Settings to run Spark on Azure

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
