# The base image must be built first, see ../docker-spark
FROM spark-azure

# Versions
ENV KYUUBI_VERSION=1.9.1

# Switch to root to copy files and set permissions
USER root

# kyuubi

ENV KYUUBI_HOME=/opt/kyuubi
ENV KYUUBI_DOWNLOAD_URL=https://dlcdn.apache.org/kyuubi/kyuubi-${KYUUBI_VERSION}/apache-kyuubi-${KYUUBI_VERSION}-bin.tgz

RUN mkdir -p ${KYUUBI_HOME} \
    && curl -fSL ${KYUUBI_DOWNLOAD_URL} -o /tmp/kyuubi.tar.gz \
    && tar -xzvf /tmp/kyuubi.tar.gz -C ${KYUUBI_HOME} --strip-components=1 \
    && rm /tmp/kyuubi.tar.gz

ENV PATH=${KYUUBI_HOME}/bin:${PATH}

# Change ownership of directories to non-root user
RUN chown -R sparkuser:sparkgroup /opt/kyuubi

# Switch to non-root user
USER sparkuser

# Expose the Kyuubi server port
EXPOSE 10009

# Start Kyuubi server and keep container running
ENTRYPOINT ["kyuubi", "run"]
