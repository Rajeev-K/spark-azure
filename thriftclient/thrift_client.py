import os
import pyodbc

# This code connects to thrift server, executes a SQL query and prints results.
# Install ODBC driver from:
# https://www.databricks.com/spark/odbc-drivers-archive#windows

# Connection string
conn_str = (
    'DRIVER=Simba Spark ODBC Driver;'
    'Host=localhost;'
    'AuthMech=2;'
    'PORT=10000;'
    'SSL=0;'
)

account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME', 'yourStorageAccount')
container = "demo"
path = "sales.csv"

# Define the path to the CSV file in Azure Blob Storage using the account name from the environment variable
csv_path = f"abfss://{container}@{account_name}.dfs.core.windows.net/{path}"


conn = pyodbc.connect(conn_str, autocommit=True)

cursor = conn.cursor()

create_table_sql = f"""
CREATE TABLE IF NOT EXISTS sales
USING csv
OPTIONS (
  path '{csv_path}',
  header 'true',
  inferSchema 'true'
)
"""

cursor.execute(create_table_sql)

query = 'SELECT * FROM sales'

cursor.execute(query)

rows = cursor.fetchall()
for row in rows:
    print(row)

conn.close()
