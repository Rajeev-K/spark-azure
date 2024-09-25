
Set the environment variable ACR to the name of your Azure Container Registry (without the `azurecr.io` part).

Login to your ACR using this command:
```
 az acr login -n %ACR%
```

Run `build-image.cmd` followed by `push-image.cmd`.

Switch to your kubernetes context, for example if your cluster is named `eagle` use this command:
```
kubectl config use-context eagle
```

Create namespace using this command:
```
create-namespace.cmd
```

To create executor template, first update the ACR name in `executor-template.yaml` then run this command:
```
create-executor-template.cmd
```

Create service account, role and role binding using these commands:
```
kubectl apply -f service-account.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f cluster-role-binding.yaml
```

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
