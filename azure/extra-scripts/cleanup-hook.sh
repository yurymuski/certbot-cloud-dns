#!/bin/sh
set -e

# azure login
az login -u $AZ_SERVICE_PRINCIPAL_NAME -p $AZ_SERVICE_PRINCIPAL_KEY --tenant $AZ_TENANT

# remove dns TXT record
az network dns record-set txt delete -g $AZURE_DNSZONE_RESOURCEGROUP -z $AZURE_DNSZONE_RESOURCENAME -n "_acme-challenge" --yes
