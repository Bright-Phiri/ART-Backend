#!/bin/bash
set -e

# Can prevent starting of server
rm -f /app/tmp/pids/server.pid

# Overwrite database configuration file in case user's local config
# file was copied during image creation
rm -f /app/config/database.yml
cp /app/config/database.yml.docker /app/config/database.yml

# Start container's main process
exec "$@"