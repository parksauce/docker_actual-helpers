#!/bin/sh
# Actual helper scripts startup

echo "Creating env file"
cat << EOF > .env
ACTUAL_SERVER_URL=$ACTUAL_SERVER_URL
ACTUAL_SERVER_PASSWORD=$ACTUAL_SERVER_PASSWORD
ACTUAL_SYNC_ID=$ACTUAL_SYNC_ID
#allow self-signed SSL certs
NODE_TLS_REJECT_UNAUTHORIZED=$NODE_TLS_REJECT_UNAUTHORIZED

# optional, for encrypted files
ACTUAL_FILE_PASSWORD=$ACTUAL_FILE_PASSWORD

# optional, if you want to use a different cache directory
ACTUAL_CACHE_DIR=$ACTUAL_CACHE_DIR

# optional, name of the payee for added interest transactions
IMPORTER_INTEREST_PAYEE_NAME=$IMPORTER_INTEREST_PAYEE_NAME

# optional, name of the payee for added interest transactions
INVESTMENT_PAYEE_NAME=$INVESTMENT_PAYEE_NAME
# optional, name of the cateogry group for added investment tracking transactions
INVESTMENT_CATEGORY_GROUP_NAME=$INVESTMENT_CATEGORY_GROUP_NAME
# optional, name of the category for added investment tracking transactions
INVESTMENT_CATEGORY_NAME=$INVESTMENT_CATEGORY_NAME

# optional, for logging into SimpleFIN
SIMPLEFIN_CREDENTIALS=$SIMPLEFIN_CREDENTIALS

# optional, for retrieving Bitcoin Price (these default to Kraken USD)
BITCOIN_PRICE_URL=$BITCOIN_PRICE_URL
BITCOIN_PRICE_JSON_PATH=$BITCOIN_PRICE_JSON_PATH
BITCOIN_PAYEE_NAME=$BITCOIN_PAYEE_NAME
EOF

echo "Running $SCRIPT"
node /app/$SCRIPT