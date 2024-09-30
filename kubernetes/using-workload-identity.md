# Using workload identity with Azure Kubernetes Service

In the description below, my AKS cluster is `gold` and its resource group is `gold-group`.

## Enable workload identity

```
az aks update --resource-group gold-group --name gold --enable-oidc-issuer --enable-workload-identity
```

Check if that worked:
```
az aks show -g gold-group -n gold --query oidcIssuerProfile.enabled
```

## Examine agentpool's managed identity

At this point, Azure documentation asks you to create a managed identity. For me, that results in "Identity not found" error later. I found that using the agentpool identity that was created as part of the cluster works.

~~Create a user-assigned managed identity.~~

~~az identity create --name myManagedIdentity --resource-group demo --location westus3~~

To get the client id:
```
az identity list --resource-group MC_gold-group_gold_westus3
```

clientId: `8e87fc5e-fb55-4f61-98c8-8f16b2176ae4`


## Create kubernetes service account:

Plug in your clientId into the yaml below:

```
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: 8e87fc5e-fb55-4f61-98c8-8f16b2176ae4
  name: spark-sa
  namespace: analytics
```

## Create federated identity credential

First retrieve OIDC issuer URL

```
az aks show --name gold --resource-group gold-group --query oidcIssuerProfile.issuerUrl
```

The url should be used as issuer below.

```
az identity federated-credential create
    --name myFederatedIdentity
    --identity-name gold-agentpool
    --resource-group demo
    --issuer "https://westus3.oic.prod-aks.azure.com/7fa18207-b300-4404-8081-662ebc77b08d/53aa724a-f0a4-4205-919e-9b467fa667e4/"
    --subject system:serviceaccount:analytics:spark-sa
    --audience api://AzureADTokenExchange
```

To verify:
```
az identity federated-credential list --resource-group MC_gold-group_gold_westus3 --identity-name gold-agentpool
```

## Assign permissions

Get the principalId first:
```
az identity show --name gold-agentpool --resource-group MC_gold-group_gold_westus3 --query principalId 
```

principalId: `7264fa93-af86-4895-aa75-f1ce0e2e58bb`

Plug it into the command below:

```
az role assignment create 
  --assignee-object-id 7264fa93-af86-4895-aa75-f1ce0e2e58bb
  --assignee-principal-type ServicePrincipal
  --role "Storage Blob Data Contributor" 
  --scope /subscriptions/50596385-d995-443a-a98b-9fcfa52f4777/resourceGroups/DefaultResourceGroup-WUS/providers/Microsoft.Storage/storageAccounts/sparkdemo2000
```

To verify:

```
az role assignment list --assignee 7264fa93-af86-4895-aa75-f1ce0e2e58bb  --scope /subscriptions/50596385-d995-443a-a98b-9fcfa52f4777/resourceGroups/DefaultResourceGroup-WUS/providers/Microsoft.Storage/storageAccounts/sparkdemo2000
```
