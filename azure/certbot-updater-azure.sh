#!/bin/bash
set -e

if [[ -z "${CERTBOT_DOMAIN}" ]]; then
  CERTBOT_DOMAIN="${1:?'please provide DOMAIN'}"
fi

if [[ -z "${CERTBOT_EMAIL}" ]]; then
  CERTBOT_EMAIL="${2:?'please set certbot email'}"
fi

if [[ -z "${CERTBOT_AZURE_SERVICE_PRINCIPAL_NAME}" ]]; then
  CERTBOT_AZURE_SERVICE_PRINCIPAL_NAME="${3:?'please provide AZURE service principal name'}"
fi

if [[ -z "${CERTBOT_AZURE_SERVICE_PRINCIPAL_KEY}" ]]; then
  CERTBOT_AZURE_SERVICE_PRINCIPAL_KEY="${4:?'please provide AZURE service principal key'}"
fi

if [[ -z "${CERTBOT_AZURE_TENANT}" ]]; then
  CERTBOT_AZURE_TENANT="${5:?'please provide AZURE tenant'}"
fi

if [[ -z "${CERTBOT_DIR}" ]]; then
  CERTBOT_DIR="${6:?'please provide local directory for certbot e.g /tmp/certbot/digitalocean'}"
fi
echo $CERTBOT_DIR && mkdir -p $CERTBOT_DIR

echo "Renew SSL for ${CERTBOT_DOMAIN}"

docker run -it --rm --name certbot \
    -v "${CERTBOT_DIR}/letsencrypt:/etc/letsencrypt" \
    -v "${PWD}/azure/extra-scripts:/ops/extra-scripts" \
    -e AZ_SERVICE_PRINCIPAL_NAME="${CERTBOT_AZURE_SERVICE_PRINCIPAL_NAME}" \
    -e AZ_SERVICE_PRINCIPAL_KEY="${CERTBOT_AZURE_SERVICE_PRINCIPAL_KEY}" \
    -e AZ_TENANT=${CERTBOT_AZURE_TENANT} \
    -e AZURE_DNSZONE_RESOURCEGROUP="dns" \
    -e AZURE_DNSZONE_RESOURCENAME=${CERTBOT_DOMAIN} \
    ymuski/certbot-azure \
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
