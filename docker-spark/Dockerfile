FROM apache/spark:3.4.1-python3

# Versions
ENV AZURE_STORAGE_VERSION=8.6.6
ENV AZURE_STORAGE_BLOB_VERSION=12.10.2
ENV HADOOP_AZURE_VERSION=3.3.1
ENV HADOOP_AZURE_DATALAKE_VERSION=3.3.1
ENV WILDFLY_OPENSSL_VERSION=2.2.5
# Delta Lake support - only needed to support "delta" format
ENV DELTA_CORE_VERSION=2.4.0
ENV DELTA_STORAGE_VERSION=2.4.0

# Switch to root to copy files and set permissions
USER root

# Create necessary directories and copy configuration files
RUN mkdir -p /opt/spark/conf /opt/spark/jars
COPY log4j.properties /opt/spark/conf/log4j.properties

# Define URLs for JAR files
ENV MAVEN=https://repo1.maven.org/maven2
ENV AZURE_STORAGE_URL=${MAVEN}/com/microsoft/azure/azure-storage/${AZURE_STORAGE_VERSION}/azure-storage-${AZURE_STORAGE_VERSION}.jar
ENV AZURE_STORAGE_BLOB_URL=${MAVEN}/com/azure/azure-storage-blob/${AZURE_STORAGE_BLOB_VERSION}/azure-storage-blob-${AZURE_STORAGE_BLOB_VERSION}.jar
ENV HADOOP_AZURE_URL=${MAVEN}/org/apache/hadoop/hadoop-azure/${HADOOP_AZURE_VERSION}/hadoop-azure-${HADOOP_AZURE_VERSION}.jar
ENV HADOOP_AZURE_DATALAKE_URL=${MAVEN}/org/apache/hadoop/hadoop-azure-datalake/${HADOOP_AZURE_DATALAKE_VERSION}/hadoop-azure-datalake-${HADOOP_AZURE_DATALAKE_VERSION}.jar
ENV WILDFLY_OPENSSL_URL=${MAVEN}/org/wildfly/openssl/wildfly-openssl/${WILDFLY_OPENSSL_VERSION}.Final/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.Final.jar
ENV DELTA_CORE_URL=${MAVEN}/io/delta/delta-core_2.12/${DELTA_CORE_VERSION}/delta-core_2.12-${DELTA_CORE_VERSION}.jar
ENV DELTA_STORAGE_URL=${MAVEN}/io/delta/delta-storage/${DELTA_STORAGE_VERSION}/delta-storage-${DELTA_STORAGE_VERSION}.jar

# Fetch JAR files
RUN curl -fSL "$AZURE_STORAGE_BLOB_URL" -o /opt/spark/jars/azure-storage-blob-${AZURE_STORAGE_BLOB_VERSION}.jar \
    && curl -fSL "$AZURE_STORAGE_URL" -o /opt/spark/jars/azure-storage-${AZURE_STORAGE_VERSION}.jar \
    && curl -fSL "$HADOOP_AZURE_URL" -o /opt/spark/jars/hadoop-azure-${HADOOP_AZURE_VERSION}.jar \
    && curl -fSL "$HADOOP_AZURE_DATALAKE_URL" -o /opt/spark/jars/hadoop-azure-datalake-${HADOOP_AZURE_DATALAKE_VERSION}.jar \
    && curl -fSL "$WILDFLY_OPENSSL_URL" -o /opt/spark/jars/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.jar \
    && curl -fSL "$DELTA_CORE_URL" -o /opt/spark/jars/delta-core_2.12-${DELTA_CORE_VERSION}.jar \
    && curl -fSL "$DELTA_STORAGE_URL" -o /opt/spark/jars/delta-storage-${DELTA_STORAGE_VERSION}.jar \
    || { echo 'Failed to download JAR files'; exit 1; }

# Create a user and group with specific UID and GID
RUN groupadd -g 1001 sparkgroup && \
    useradd -r -u 1001 -g sparkgroup sparkuser

# Change ownership of directories to non-root user
RUN chown -R sparkuser:sparkgroup /opt/spark

# Make home directory
RUN mkdir -p /home/sparkuser
RUN chown sparkuser:sparkgroup /home/sparkuser

# Switch to non-root user
USER sparkuser

ENV HADOOP_USER_NAME=sparkuser
