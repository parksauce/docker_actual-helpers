# Stage 1: Get Dependencies
FROM alpine:latest AS build

# Install git
RUN apk add --no-cache git

WORKDIR /app

# Clone the repository
RUN git clone https://github.com/psybers/actual-helpers.git

# Stage 2: Package
FROM node:21-alpine

# Define environment variables
ENV ACTUAL_SERVER_URL=""
ENV ACTUAL_SERVER_PASSWORD=""
ENV ACTUAL_SYNC_ID=""
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
ENV ACTUAL_FILE_PASSWORD=""
ENV ACTUAL_CACHE_DIR="./cache"
ENV INTEREST_PAYEE_NAME=""
ENV INVESTMENT_PAYEE_NAME=""
ENV INVESTMENT_CATEGORY_GROUP_NAME=""
ENV INVESTMENT_CATEGORY_NAME=""
ENV SIMPLEFIN_CREDENTIALS=""
ENV BITCOIN_PRICE_URL=""
ENV BITCOIN_PRICE_JSON_PATH=""
ENV BITCOIN_PAYEE_NAME=""
ENV SCRIPT="sync-banks.js"

# Copy build artifacts
COPY --from=build /app/actual-helpers /app
COPY init.sh /app

WORKDIR /app

# Install dependencies
RUN chmod +x /app/init.sh && \
    npm install

# Define entrypoint
ENTRYPOINT ["/bin/sh", "-c", "/app/init.sh"]