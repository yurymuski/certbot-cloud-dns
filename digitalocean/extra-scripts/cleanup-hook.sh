#!/bin/sh
set -e

# doctl login
doctl auth init ${CERTBOT_DIGITALOCEAN_TOKEN}

# get record id's
RECORD_ID_LIST=$(doctl compute domain records list ${CERTBOT_DOMAIN} | grep -E '(^|\s)_acme-challenge($|\s)' | awk 'NR > 1 { print $1 }')

# remove dns TXT record
echo $RECORD_ID_LIST |  while read -r RECORD_ID; do
    doctl compute domain records delete ${CERTBOT_DOMAIN} $RECORD_ID_LIST -f
done
