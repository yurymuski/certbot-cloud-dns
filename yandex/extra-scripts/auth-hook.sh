#!/bin/sh
set -e

# set dns TXT record
YANDEX_DNSZONE_ID=$(yc dns zone list --folder-id $YANDEX_FOLDER_ID --token $YANDEX_TOKEN --format json | jq ".[] | select(.zone == \"$YANDEX_DNS_ZONE.\") | .id")
yc dns zone add-records --record "_acme-challenge TXT $CERTBOT_VALIDATION" --id $YANDEX_DNSZONE_ID --folder-id $YANDEX_FOLDER_ID --token $YANDEX_TOKEN 

# w8
sleep 20
