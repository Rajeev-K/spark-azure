FROM spark-azure

# This docker image will be used by both driver and executors

# Port number for thrift
EXPOSE 10000

# Note: Both ENTRYPOINT and CMD in the Dockerfile are overridden by Spark when it starts the driver and executor pods.

CMD ["/bin/sh", "-c", "sleep infinity"]
