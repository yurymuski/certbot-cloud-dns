#!/bin/bash
set -e

if [[ -z "${CERTBOT_DOMAIN}" ]]; then
  CERTBOT_DOMAIN="${1:?'please provide DOMAIN'}"
fi

if [[ -z "${CERTBOT_EMAIL}" ]]; then
  CERTBOT_EMAIL="${2:?'please set certbot email'}"
fi

if [[ -z "${CERTBOT_CLOUDFLARE_TOKEN}" ]]; then
  CERTBOT_CLOUDFLARE_TOKEN="${3:?'please provide CLOUDFLARE token'}"
fi

if [[ -z "${CERTBOT_DIR}" ]]; then
  CERTBOT_DIR="${4:?'please provide local directory for certbot e.g /tmp/certbot/cloudflare'}"
fi
echo $CERTBOT_DIR && mkdir -p $CERTBOT_DIR


mkdir -p "${CERTBOT_DIR}/.secrets"
echo "dns_cloudflare_api_token = ${CERTBOT_CLOUDFLARE_TOKEN}" > ${CERTBOT_DIR}/.secrets/cloudflare-credentials.ini
chmod 600 ${CERTBOT_DIR}/.secrets/cloudflare-credentials.ini

echo "Renew SSL for ${CERTBOT_DOMAIN}"

docker run -it --rm --name certbot \
    -v "${CERTBOT_DIR}/letsencrypt:/etc/letsencrypt" \
    -v "${CERTBOT_DIR}/.secrets:/opt/.secrets" \
    certbot/dns-cloudflare \
    certonly \
        --dns-cloudflare \
        --dns-cloudflare-credentials /opt/.secrets/cloudflare-credentials.ini \
        --dns-cloudflare-propagation-seconds 30 \
        --manual-cleanup-hook "/ops/extra-scripts/cleanup-hook.sh" \
        -d ${CERTBOT_DOMAIN} \
        -d *.${CERTBOT_DOMAIN} \
        --agree-tos \
        --noninteractive \
        --server https://acme-v02.api.letsencrypt.org/directory \
        --email ${CERTBOT_EMAIL} \
        --no-eff-email \
        # --force-renewal
