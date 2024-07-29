#!/bin/sh
# Actual helper scripts startup

echo "Creating env file"
cat << EOF > .env
ACTUAL_SERVER_URL=$ACTUAL_SERVER_URL
ACTUAL_SERVER_PASSWORD=$ACTUAL_SERVER_PASSWORD
ACTUAL_SYNC_ID=$ACTUAL_SYNC_ID

# optional, for encrypted files
ACTUAL_FILE_PASSWORD=$ACTUAL_FILE_PASSWORD

# optional, if you want to use a different cache directory
ACTUAL_CACHE_DIR=$ACTUAL_CACHE_DIR

# optional, name of the payee for added interest transactions
IMPORTER_INTEREST_PAYEE_NAME=$IMPORTER_INTEREST_PAYEE_NAME
EOF

echo "Running $SCRIPT"
node /app/$SCRIPT