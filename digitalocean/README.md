Script requires 4 vars and positional arguments or environment variables

  - **CERTBOT_DOMAIN** or 1st arg
  - **CERTBOT_EMAIL** or 2nd arg
  - **CERTBOT_DIGITALOCEAN_TOKEN** or 3rd arg
  - **CERTBOT_DIR** or 4th arg

```sh
# Executing with args
./digitalocean/certbot-updater-digitalocean.sh YOUR_DOMAIN YOUR_EMAIL YOUR_DO_TOKEN YOUR_DIR

# Executing with ENV vars
export CERTBOT_DOMAIN="YOUR_DOMAIN"
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_DIGITALOCEAN_TOKEN="YOUR_DO_TOKEN"
export CERTBOT_DIR="YOUR_DIR"
./digitalocean/certbot-updater-digitalocean.sh

```

After execution you can copy certs somewhere:
```sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
```

## Usage example

```sh
chmod +x ./digitalocean/certbot-updater-digitalocean.sh

# iterate over list
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_DIGITALOCEAN_TOKEN="YOUR_DO_TOKEN"
export CERTBOT_DIR="YOUR_DIR"

for DOMAIN in `cat domain_list_digitalocean.txt`; do
  echo updating certs for ${DOMAIN}
  export CERTBOT_DOMAIN="${DOMAIN}"
  ./digitalocean/certbot-updater-digitalocean.sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
done

```