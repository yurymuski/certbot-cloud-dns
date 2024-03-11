#!/bin/bash

set -e

# Headers
AUTH_HEADER="Authorization: Bearer $CERTBOT_CLOUDFLARE_TOKEN"
CONTENT_TYPE="Content-Type: application/json"

# Get Zone ID for the domain
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$CERTBOT_DOMAIN" -H "$CONTENT_TYPE" -H "$AUTH_HEADER" | jq -r '.result[0].id')

# Get record IDs for _acme-challenge and delete them
RECORD_IDS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=TXT&name=_acme-challenge.$CERTBOT_DOMAIN" -H "$AUTH_HEADER" -H "$CONTENT_TYPE" | jq -r '.result[].id')

# remove dns TXT record
for RECORD_ID in $RECORD_IDS; do
    curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" -H "$AUTH_HEADER" -H "$CONTENT_TYPE"
done

