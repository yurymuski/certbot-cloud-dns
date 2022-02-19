#!/bin/sh
set -e

# azure login
az login -u $AZ_SERVICE_PRINCIPAL_NAME -p $AZ_SERVICE_PRINCIPAL_KEY --tenant $AZ_TENANT

# set dns TXT record
az network dns record-set txt add-record -g $AZURE_DNSZONE_RESOURCEGROUP -z $AZURE_DNSZONE_RESOURCENAME -n "_acme-challenge" -v $CERTBOT_VALIDATION

# w8
sleep 20
