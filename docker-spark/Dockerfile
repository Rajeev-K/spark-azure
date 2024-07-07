FROM apache/spark-py:v3.4.0

# Versions
ENV AZURE_STORAGE_BLOB_VERSION=12.10.2
ENV HADOOP_AZURE_VERSION=3.2.0
ENV WILDFLY_OPENSSL_VERSION=2.2.5

# Switch to root to copy files and set permissions
USER root

# Create a user and group with specific UID and GID
RUN groupadd -g 1001 sparkgroup && \
    useradd -r -u 1001 -g sparkgroup sparkuser

# Create necessary directories and copy configuration files
RUN mkdir -p /opt/spark/conf /opt/spark/jars
COPY log4j.properties /opt/spark/conf/log4j.properties

# Define URLs for JAR files
ENV AZURE_STORAGE_BLOB_URL=https://repo1.maven.org/maven2/com/azure/azure-storage-blob/${AZURE_STORAGE_BLOB_VERSION}/azure-storage-blob-${AZURE_STORAGE_BLOB_VERSION}.jar
ENV HADOOP_AZURE_URL=https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_AZURE_VERSION}/hadoop-azure-${HADOOP_AZURE_VERSION}.jar
ENV WILDFLY_OPENSSL_URL=https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/${WILDFLY_OPENSSL_VERSION}.Final/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.Final.jar

# Fetch JAR files
RUN curl -fSL "$AZURE_STORAGE_BLOB_URL" -o /opt/spark/jars/azure-storage-blob-${AZURE_STORAGE_BLOB_VERSION}.jar \
    && curl -fSL "$HADOOP_AZURE_URL" -o /opt/spark/jars/hadoop-azure-${HADOOP_AZURE_VERSION}.jar \
    && curl -fSL "$WILDFLY_OPENSSL_URL" -o /opt/spark/jars/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.jar \
    || { echo 'Failed to download JAR files'; exit 1; }

# Change ownership of directories to non-root user
RUN chown -R sparkuser:sparkgroup /opt/spark

# Switch to non-root user
USER sparkuser
