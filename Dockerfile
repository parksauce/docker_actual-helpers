# Stage 1: Build Stage
FROM alpine:latest AS build

# Install Node.js and npm (and git if needed)
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/psybers/actual-helpers.git

# Stage 2: Final Stage
FROM node:21-alpine

ENV ACTUAL_SERVER_URL=""
ENV ACTUAL_SERVER_PASSWORD=""
ENV ACTUAL_SYNC_ID=""
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
ENV ACTUAL_FILE_PASSWORD=""
ENV ACTUAL_CACHE_DIR="./cache"
ENV IMPORTER_INTEREST_PAYEE_NAME=""
ENV INVESTMENT_PAYEE_NAME=""
ENV INVESTMENT_CATEGORY_GROUP_NAME=""
ENV INVESTMENT_CATEGORY_NAME=""
ENV SIMPLEFIN_CREDENTIALS=""
ENV BITCOIN_PRICE_URL=""
ENV BITCOIN_PRICE_JSON_PATH=""
ENV BITCOIN_PAYEE_NAME=""
ENV SCRIPT="sync-banks.js"

# Copy built artifacts from the build stage
COPY --from=build /app/actual-helpers /app
COPY init.sh /app

WORKDIR /app

# Install dependencies and build the project
RUN chmod +x /app/init.sh && \
    npm install

ENTRYPOINT ["/bin/sh", "-c", "/app/init.sh"]