# GitHub Actions

## Sign up for GitHub Actions

Open <https://github.com/features/actions> and click "Sign up for beta"

## Create Azure Service Principal and GitHub Actions Secret

1. Open <https://shell.azure.com/> and run the following snippet:
```bash
SUBSCRIPTION_ID=$(az account show | jq -r .id)
RESOURCE_GROUP='191000-cloud-actions'
LOCATION='eastus'
SP_NAME='http://191000-cloud-actions'

# create service principal
SP=$(az ad sp create-for-rbac --sdk-auth --skip-assignment -n $SP_NAME)
SP_ID=$(echo $SP | jq -r .clientId)
# create resource group
az group create -n $RESOURCE_GROUP -l $LOCATION
# assign contributor role to service principal at resource group scope
az role assignment create --assignee $SP_ID --role Contributor \
    --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}"
# output service principal
echo $SP
```
2. Copy the JSON above and create a secret `AZURE_CREDENTIALS` under `Settings > Secrets` in your GitHub repository (e.g. <https://github.com/python-azure/python-actions-aks/settings/secrets>).
