#!/bin/bash

# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
ACR_NAME=acr0myapp485959
SERVICE_PRINCIPAL_NAME=acrpull-sp-role

# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
CLIENT_SECRET=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role Owner --query password --output tsv)
CLIENT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)
TENANT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appOwnerTenantId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID (Client ID)          : $CLIENT_ID"
echo "Service principal password (Client Secret): $CLIENT_SECRET"
echo "Service principal Tenant (Tenant ID)      : $TENANT_ID"

az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
