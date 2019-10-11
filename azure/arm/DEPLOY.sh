#!/usr/bin/env bash

# variables
RESOURCE_GROUP='191000-cloud-actions'
LOCATION='eastus'

SUBSCRIPTION_ID=$(az account show | jq -r .id)
SP_NAME=$(echo $AZURE_CREDENTIALS | jq -r .name)
SP_CLIENT_ID=$(echo $AZURE_CREDENTIALS | jq -r .appId)
SP_CLIENT_SECRET=$(echo $AZURE_CREDENTIALS | jq -r .password)
DEPLOYMENT_NAME="191000-aks-1"
AKS_NAME="aks1"

# az group deployment create --resource-group $RESOURCE_GROUP \
#    --template-file empty.json \
#    --mode 'Complete'

az group deployment create --name $DEPLOYMENT_NAME --resource-group $RESOURCE_GROUP  \
    --template-uri https://raw.githubusercontent.com/asw101/cloud-snips/master/arm/aks/azuredeploy.json \
    --mode 'Complete' \
    --parameters \
    clusterName=$AKS_NAME \
    location=$LOCATION \
    servicePrincipalClientId=$SP_CLIENT_ID \
    servicePrincipalClientSecret=$SP_CLIENT_SECRET \
    agentCount=1 \
    agentVMSize=Standard_B2s \
    | jq -c .
