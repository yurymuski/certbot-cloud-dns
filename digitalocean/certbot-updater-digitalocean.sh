#!/bin/bash
set -ex

if [[ -z "${CERTBOT_DOMAIN}" ]]; then
  CERTBOT_DOMAIN="${1:?'please provide DOMAIN'}"
fi

if [[ -z "${CERTBOT_EMAIL}" ]]; then
  CERTBOT_EMAIL="${2:?'please set certbot email'}"
fi

if [[ -z "${CERTBOT_DIGITALOCEAN_TOKEN}" ]]; then
  CERTBOT_DIGITALOCEAN_TOKEN="${3:?'please provide DIGITALOCEAN token'}"
fi

if [[ -z "${CERTBOT_DIR}" ]]; then
  CERTBOT_DIR="${4:?'please provide local directory for certbot e.g /tmp/certbot/digitalocean'}"
fi
echo $CERTBOT_DIR


mkdir -p "${CERTBOT_DIR}/.secrets"
echo "dns_digitalocean_token = ${CERTBOT_DIGITALOCEAN_TOKEN}" > ${CERTBOT_DIR}/.secrets/digitalocean-credentials.ini

echo "Renew SSL for ${CERTBOT_DOMAIN}"

docker run -it --rm --name certbot \
    -v "${CERTBOT_DIR}/letsencrypt:/etc/letsencrypt" \
    -v "${CERTBOT_DIR}/.secrets:/opt/.secrets" \
    certbot/dns-digitalocean \
    certonly \
        --dns-digitalocean \
        --dns-digitalocean-credentials /opt/.secrets/digitalocean-credentials.ini \
        --dns-digitalocean-propagation-seconds 30 \
        -d ${CERTBOT_DOMAIN} \
        -d *.${CERTBOT_DOMAIN} \
        --agree-tos \
        --noninteractive \
        --server https://acme-v02.api.letsencrypt.org/directory \
        --email ${CERTBOT_EMAIL} \
        --no-eff-email \
        # --force-renewal
