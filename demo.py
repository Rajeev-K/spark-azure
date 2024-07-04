import os
from pyspark.sql import SparkSession

# Retrieve the Azure storage account name and access key from environment variables
account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME')
account_key = os.getenv('AZURE_STORAGE_ACCESS_KEY')
container = "demo"

# Create a Spark session
spark = SparkSession.builder \
    .appName("demo") \
    .config(f"spark.hadoop.fs.azure.account.auth.type.{account_name}.dfs.core.windows.net", "SharedKey") \
    .config(f"spark.hadoop.fs.azure.account.key.{account_name}.dfs.core.windows.net", account_key) \
    .getOrCreate()

# Define the path to the CSV file in Azure Blob Storage using the account name from the environment variable
csv_path = f"abfss://{container}@{account_name}.dfs.core.windows.net/sales.csv"

# Read the CSV file into a DataFrame
df = spark.read.csv(csv_path, header=True, inferSchema=True)

# Write the DataFrame to Parquet format
df.write.mode("overwrite").format("parquet").save("/files/output")

# Stop the Spark session
spark.stop()
