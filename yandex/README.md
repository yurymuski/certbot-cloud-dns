Script requires 5 vars as positional arguments or environment variables

  - **CERTBOT_DOMAIN** or 1st arg
  - **CERTBOT_EMAIL** or 2nd arg
  - **CERTBOT_YANDEX_TOKEN** or 3rd arg
  - **CERTBOT_YANDEX_FOLDER_ID** or 4rd arg
  - **CERTBOT_DIR** or 5th arg

```sh
# Executing with args
./yandex/certbot-updater-yandex.sh YOUR_DOMAIN YOUR_EMAIL CERTBOT_YANDEX_TOKEN CERTBOT_YANDEX_FOLDER_ID YOUR_DIR

# Executing with ENV vars
export CERTBOT_DOMAIN="YOUR_DOMAIN"
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_YANDEX_TOKEN="YOUR_YANDEX_TOKEN"
export CERTBOT_YANDEX_FOLDER_ID="YOUR_YANDEX_FOLDER_ID"
export CERTBOT_DIR="YOUR_DIR"
chmod +x ./yandex/certbot-updater-yandex.sh
./yandex/certbot-updater-yandex.sh

```

After execution you can copy certs somewhere:
```sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
```

## Usage example

```sh
chmod +x ./yandex/certbot-updater-yandex.sh

# iterate over list
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_YANDEX_TOKEN="YOUR_YANDEX_TOKEN"
export CERTBOT_YANDEX_FOLDER_ID="YOUR_YANDEX_FOLDER_ID"
export CERTBOT_DIR="YOUR_DIR"

for DOMAIN in `cat domain_list_yandex.txt`; do
  echo updating certs for ${DOMAIN}
  export CERTBOT_DOMAIN="${DOMAIN}"
  ./yandex/certbot-updater-yandex.sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
done

```
