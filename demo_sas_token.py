import os
from pyspark.sql import SparkSession

storage_account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME', 'yourStorageAccount')
sas_token = os.getenv('SAS_TOKEN')
container_name = "demo"
path = "sales.csv"

# Create a Spark session
spark = SparkSession.builder \
    .appName("AzureADLSGen2Example") \
    .getOrCreate()

# Set the Spark configuration to use the SAS token
spark.conf.set(f"fs.azure.sas.{container_name}.{storage_account_name}.dfs.core.windows.net", sas_token)

# Define the path to the blob using the abfss scheme
csv_path = f"abfss://{container_name}@{storage_account_name}.dfs.core.windows.net/{path}"

# Read data from the blob into a DataFrame
df = spark.read.option("header", "true").csv(csv_path)

# Show the DataFrame
df.show()

# Stop the Spark session
spark.stop()

