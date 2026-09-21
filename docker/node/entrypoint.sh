#!/bin/sh
set -e

echo "🔧 Fetching config from SCC Service..."

RESPONSE=$(wget -q -O - \
  --header="X-API-Key: ${SCC_API_KEY}" \
  "${SCC_URL}/config/${APP_NAME}")

if [ -z "$RESPONSE" ]; then
  echo "❌ Failed to fetch config from SCC Service"
  exit 1
fi

# Convert JSON ke .env pakai jq
echo "$RESPONSE" | jq -r 'to_entries[] | "\(.key)=\(.value)"' > /app/.env

echo "✅ Config loaded successfully"

echo "🚀 Starting application..."
exec node dist/server.js