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
ENV ACTUAL_FILE_PASSWORD=""
ENV ACTUAL_CACHE_DIR="./cache"
ENV IMPORTER_INTEREST_PAYEE_NAME=""
ENV SCRIPT="sync-banks.js"

# Copy built artifacts from the build stage
COPY --from=build /app/actual-helpers /app
COPY init.sh /app

WORKDIR /app

# Install dependencies and build the project
RUN chmod +x /app/init.sh && \
    npm install #@actual-app/api dotenv jsdom && \
    #npm install

CMD ["/bin/sh", "-c", "/app/init.sh"]
