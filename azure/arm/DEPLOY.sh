#!/usr/bin/env bash

# variables
RESOURCE_GROUP='191000-cloud-actions'
LOCATION='eastus'
# via: .github/workflows-4-action-azure-aks.yml
# SP_CLIENT_ID
# SP_CLIENT_SECRET

SUBSCRIPTION_ID=$(az account show | jq -r .id)
DEPLOYMENT_NAME="191000-aks-1"
AKS_NAME="aks1"

# az group deployment create --resource-group $RESOURCE_GROUP \
#    --template-file empty.json \
#    --mode 'Complete'

# aks
az group deployment create --name $DEPLOYMENT_NAME --resource-group $RESOURCE_GROUP  \
    --template-uri https://raw.githubusercontent.com/asw101/cloud-snips/master/arm/aks/azuredeploy.json \
    --mode 'Incremental' \
    --parameters \
    clusterName=$AKS_NAME \
    location=$LOCATION \
    servicePrincipalClientId=$SP_CLIENT_ID \
    servicePrincipalClientSecret=$SP_CLIENT_SECRET \
    agentCount=1 \
    agentVMSize=Standard_B2s \
    | jq -c .

# acr
DEPLOYMENT_NAME="191000-acr-1"
az group deployment create --name $DEPLOYMENT_NAME --resource-group $RESOURCE_GROUP \
    --template-uri https://raw.githubusercontent.com/asw101/cloud-snips/master/arm/acr/azuredeploy.json \
    --mode 'Incremental'

# aks + acr role assignment
# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $RESOURCE_GROUP --name $AKS_NAME --query "servicePrincipalProfile.clientId" --output tsv)
# Get the ACR registry resource id
ACR_ID=$(az acr list -g $RESOURCE_GROUP | jq -r .[0].id)
# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID
