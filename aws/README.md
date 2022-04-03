NOTE: AWS IAM policy might be needed:
  - [Single domain](iam-policy/certbot-dns-route53-single.json)
  - [ALL domains](iam-policy/certbot-dns-route53-all.json)

Script requires 5 vars as positional arguments or environment variables

  - **CERTBOT_DOMAIN** or 1st arg
  - **CERTBOT_EMAIL** or 2nd arg
  - **CERTBOT_AWS_ACCESS_KEY_ID** or 3rd arg
  - **CERTBOT_AWS_SECRET_ACCESS_KEY** or 4th arg
  - **CERTBOT_DIR** or 5th arg

```sh
# Executing with args
./aws/certbot-updater-aws.sh YOUR_DOMAIN YOUR_EMAIL YOUR_AWS_ACCESS_KEY_ID YOUR_AWS_SECRET_ACCESS_KEY YOUR_DIR

# Executing with ENV vars
export CERTBOT_DOMAIN="YOUR_DOMAIN"
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
export CERTBOT_AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export CERTBOT_DIR="YOUR_DIR"
chmod +x ./aws/certbot-updater-aws.sh
./aws/certbot-updater-aws.sh

```

After execution you can copy certs somewhere:
```sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
```

## Usage example

```sh
chmod +x ./aws/certbot-updater-aws.sh

# iterate over list
export CERTBOT_EMAIL="YOUR_EMAIL"
export CERTBOT_AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
export CERTBOT_AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
export CERTBOT_DIR="YOUR_DIR"

for DOMAIN in `cat domain_list_aws.txt`; do
  echo updating certs for ${DOMAIN}
  export CERTBOT_DOMAIN="${DOMAIN}"
  ./aws/certbot-updater-aws.sh
  sudo chown $(id -u):$(id -g) -R ${CERTBOT_DIR}
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.crt
  cp -L ${CERTBOT_DIR}/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ./nginx/certs/wildcard.${CERTBOT_DOMAIN}.key
done

```
