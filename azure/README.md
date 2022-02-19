Script requires 6 vars as positional arguments or environment variables

  - **CERTBOT_DOMAIN** or 1st arg
  - **CERTBOT_EMAIL** or 2nd arg
  - **AZ_SERVICE_PRINCIPAL_NAME** or 3rd arg
  - **AZ_SERVICE_PRINCIPAL_KEY** or 4rd arg
  - **AZ_TENANT** or 5rd arg
  - **CERTBOT_DIR** or 6th arg

```sh
# Executing with args
./azure/certbot-updater-azure.sh YOUR_DOMAIN YOUR_EMAIL YOUR_AZURE_USERNAME YOUR_AZURE_PASS YOUR_AZURE_TENANT YOUR_DIR

# Executing with ENV vars
export CERTBOT_DOMAIN="YOUR_DOMAIN"
export CERTBOT_EMAIL="YOUR_EMAIL"
export AZ_SERVICE_PRINCIPAL_NAME="YOUR_AZURE_USERNAME"
export AZ_SERVICE_PRINCIPAL_KEY="YOUR_AZURE_PASS"
export AZ_TENANT="YOUR_AZURE_TENANT"
export CERTBOT_DIR="YOUR_DIR"
./azure/certbot-updater-azure.sh

```

After execution you can copy certs somewhere:
```sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
```

## Usage example

```sh
chmod +x ./azure/certbot-updater-azure.sh

# iterate over list
export CERTBOT_EMAIL="YOUR_EMAIL"
export AZ_SERVICE_PRINCIPAL_NAME="YOUR_AZURE_USERNAME"
export AZ_SERVICE_PRINCIPAL_KEY="YOUR_AZURE_PASS"
export AZ_TENANT="YOUR_AZURE_TENANT"
export CERTBOT_DIR="YOUR_DIR"

for DOMAIN in `cat domain_list_azure.txt`; do
  echo updating certs for ${DOMAIN}
  export CERTBOT_DOMAIN="${DOMAIN}"
  ./azure/certbot-updater-azure.sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
done

```
