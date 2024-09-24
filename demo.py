import os
from pyspark.sql import SparkSession

account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME', 'yourStorageAccount')
container = "demo"
path = "sales.csv"

# Create a Spark session
spark = SparkSession.builder \
    .appName("demo") \
    .getOrCreate()

# Define the path to the CSV file in Azure Blob Storage using the account name from the environment variable
csv_path = f"abfss://{container}@{account_name}.dfs.core.windows.net/{path}"

# Read the CSV file into a DataFrame
df = spark.read.csv(csv_path, header=True, inferSchema=True)

# Write the DataFrame to Parquet format
df.write.mode("overwrite").format("parquet").save("/files/output")
print("Data written to output folder")

# Stop the Spark session
spark.stop()
