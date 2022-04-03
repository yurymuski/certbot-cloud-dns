#!/bin/bash
set -e

if [[ -z "${CERTBOT_DOMAIN}" ]]; then
  CERTBOT_DOMAIN="${1:?'please provide DOMAIN'}"
fi

if [[ -z "${CERTBOT_EMAIL}" ]]; then
  CERTBOT_EMAIL="${2:?'please set certbot email'}"
fi

if [[ -z "${CERTBOT_AWS_ACCESS_KEY_ID}" ]]; then
  CERTBOT_AWS_ACCESS_KEY_ID="${3:?'please provide AWS_ACCESS_KEY_ID'}"
fi

if [[ -z "${CERTBOT_AWS_SECRET_ACCESS_KEY}" ]]; then
  CERTBOT_AWS_SECRET_ACCESS_KEY="${4:?'please provide AWS_SECRET_ACCESS_KEY'}"
fi

if [[ -z "${CERTBOT_DIR}" ]]; then
  CERTBOT_DIR="${5:?'please provide local directory for certbot e.g /tmp/certbot/aws'}"
fi

echo $CERTBOT_DIR && mkdir -p $CERTBOT_DIR

echo "Renew SSL for ${CERTBOT_DOMAIN}"

docker run -it --rm --name certbot \
    -v "${CERTBOT_DIR}/letsencrypt:/etc/letsencrypt" \
    -e AWS_ACCESS_KEY_ID=${CERTBOT_AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${CERTBOT_AWS_SECRET_ACCESS_KEY} \
    certbot/dns-route53 \
    certonly \
        --dns-route53 \
        --dns-route53-propagation-seconds 30 \
        -d ${CERTBOT_DOMAIN} \
        -d *.${CERTBOT_DOMAIN} \
        --agree-tos \
        --noninteractive \
        --server https://acme-v02.api.letsencrypt.org/directory \
        --email ${CERTBOT_EMAIL} \
        --no-eff-email \
        # --force-renewal
