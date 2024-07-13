import os
from pyspark.sql import SparkSession

account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME', 'yourStorageAccount')
container = "demo"
path = "test"

# Create a Spark session
spark = SparkSession.builder \
    .appName("demo") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .getOrCreate()

# Define the path to the data file
data_file_path = f"abfss://{container}@{account_name}.dfs.core.windows.net/{path}"

# Read the data file into a DataFrame
df = spark.read.format("delta").load(data_file_path)

# Write the DataFrame to output file
df.write.mode("overwrite").format("delta").save("/files/output")

# Stop the Spark session
spark.stop()
