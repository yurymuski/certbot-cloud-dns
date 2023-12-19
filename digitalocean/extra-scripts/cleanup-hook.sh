#!/bin/sh
set -e

# doctl login
doctl auth init ${CERTBOT_DIGITALOCEAN_TOKEN}

# get domain id's
DOMAIN_LIST=$(doctl compute domain records list ${CERTBOT_DOMAIN} | grep -E '(^|\s)_acme-challenge($|\s)' | awk 'NR > 1 { print $1 }')

# force delete txt records
for domains_to_remove in $DOMAIN_LIST; do
    doctl compute domain records delete ${CERTBOT_DOMAIN} $DOMAIN_LIST -f
done
