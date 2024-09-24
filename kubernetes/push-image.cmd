if "%ACR%" == "" (
    echo Set ACR environment variable to the name of your Azure Container Registry.
    exit /b 1
)

REM You will need to login into your ACR using the following command:
REM az acr login -n %ACR%

docker tag spark-k8s
docker tag spark-k8s:latest %ACR%.azurecr.io/spark-k8s
docker push %ACR%.azurecr.io/spark-k8s
