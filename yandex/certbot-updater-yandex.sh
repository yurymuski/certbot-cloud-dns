#!/bin/bash
set -e

if [[ -z "${CERTBOT_DOMAIN}" ]]; then
  CERTBOT_DOMAIN="${1:?'please provide DOMAIN'}"
fi

if [[ -z "${CERTBOT_EMAIL}" ]]; then
  CERTBOT_EMAIL="${2:?'please set certbot email'}"
fi

if [[ -z "${CERTBOT_YANDEX_TOKEN}" ]]; then
  CERTBOT_YANDEX_TOKEN="${3:?'please provide yandex O-Auth token'}"
fi

if [[ -z "${CERTBOT_YANDEX_FOLDER_ID}" ]]; then
  CERTBOT_YANDEX_FOLDER_ID="${4:?'please provide folder id'}"
fi

if [[ -z "${CERTBOT_DIR}" ]]; then
  CERTBOT_DIR="${5:?'please provide local directory for certbot e.g /tmp/certbot/digitalocean'}"
fi
echo $CERTBOT_DIR && mkdir -p $CERTBOT_DIR

echo "Renew SSL for ${CERTBOT_DOMAIN}"

docker run -it --rm --name certbot \
    -v "${CERTBOT_DIR}/letsencrypt:/etc/letsencrypt" \
    -v "${PWD}/yandex/extra-scripts:/ops/extra-scripts" \
    -e YANDEX_TOKEN="${CERTBOT_YANDEX_TOKEN}" \
    -e YANDEX_FOLDER_ID="${CERTBOT_YANDEX_FOLDER_ID}" \
    -e YANDEX_DNS_ZONE=${CERTBOT_DOMAIN} \
    ymuski/certbot-yandex:latest \
    certonly --manual \
        --manual-auth-hook "/ops/extra-scripts/auth-hook.sh" \
        --manual-cleanup-hook "/ops/extra-scripts/cleanup-hook.sh" \
        --disable-hook-validation \
        --preferred-challenges "dns-01" \
        --manual-public-ip-logging-ok \
        -d ${CERTBOT_DOMAIN} \
        -d *.${CERTBOT_DOMAIN} \
        --agree-tos \
        --noninteractive \
        --email ${CERTBOT_EMAIL} \
        --no-eff-email \
        # --force-renewal
