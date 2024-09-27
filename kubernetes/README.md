## Running Spark Thrift on Kubernetes

Set the environment variable ACR to the name of your Azure Container Registry (without the `azurecr.io` part).

Login to your ACR using this command:
```
 az acr login -n %ACR%
```

First create the base image by running `build-image.cmd` in `docker-spark` folder.

Then run `build-image.cmd` in `kubernetes` folder, followed by `push-image.cmd`.

Switch to your kubernetes context, for example if your cluster is named `eagle` use this command:
```
kubectl config use-context eagle
```

Create namespace using this command:
```
create-namespace.cmd
```

### Storage account authentication

Use Service Connector tab of AKS to create a connection to your storage account.

When creating a connection supply the namespace created above. Set Client type to Java. In Authentication tab choose Workload identity.

When the connection is ready get the value of you'll get AZURE_STORAGEBLOB_CLIENTID, this is the clientId of your managed identity.

### Create Kubernetes resources

To create executor template, first **edit executor-template.yaml** and update the ACR name, then run this command:
```
create-executor-template.cmd
```

**Edit service-account.yaml** and update the clientId of managed identity.

Create service account, role and role binding using these commands:
```
kubectl apply -f service-account.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f cluster-role-binding.yaml
```

**Edit thrift-deployment.yaml** and update the ACR, storage account name, and the clientId of your managed identity.

Create thrift service and deployment using these commands:
```
kubectl apply -f thrift-service.yaml
kubectl apply -f thrift-deployment.yaml
```

Review pods using this command:
```
kubectl -n analytics get pods
```

You should see a driver pod and multiple executor pods, here's an example:
```
NAME                                              READY   STATUS    RESTARTS   AGE
thrift-85486f764d-5qgn6                           1/1     Running   0          66s
thrift-jdbc-odbc-server-f7179a922a60e981-exec-1   1/1     Running   0          30s
thrift-jdbc-odbc-server-f7179a922a60e981-exec-2   1/1     Running   0          29s
```

Review executor pods logs using a command similar to:
```
kubectl -n analytics logs thrift-jdbc-odbc-server-f7179a922a60e981-exec-2
```
You should see the following snippets somewhere in the logs:
```
...Successfully registered with driver...
...Executor: Starting executor...
```

## Run thrift client

You will first need to port-forward by running this command:
```
port-forward.cmd
```

Now your Spark ODBC/JDBC driver can connect to localhost:10000 to run SQL commands on your Kubernetes cluster.
