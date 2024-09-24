if "%ACR%" == "" (
    echo Set ACR environment variable to the name of your Azure Container Registry.
    exit /b 1
)

REM You will need to login into your ACR using the following command:
REM az acr login -n %ACR%

docker tag diag:latest %ACR%.azurecr.io/diag
docker push %ACR%.azurecr.io/diag
