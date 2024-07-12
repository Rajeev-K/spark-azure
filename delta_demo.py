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
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .getOrCreate()

# Define the path to the data file
data_file_path = f"abfss://{container}@{account_name}.dfs.core.windows.net/test"

# Read the data file into a DataFrame
df = spark.read.format("delta").load(data_file_path)

# Write the DataFrame to output file
df.write.mode("overwrite").format("delta").save("/files/output")

# Stop the Spark session
spark.stop()
