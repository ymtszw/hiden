#!/usr/bin/env bash
# macOS / Linux quota checker for language_server (Antigravity)
set -euo pipefail

PID=$(pgrep -f "language_server" | head -n 1 || true)
if [ -z "$PID" ]; then
  echo '{"status":"fallback","reason":"language_server not running"}'
  exit 0
fi

# Extract CSRF token from command line
CSRF_TOKEN=$(ps -p "$PID" -o command= | grep -oE -- '--csrf_token[ =][^ ]+' | awk '{print $2}' || true)
if [ -z "$CSRF_TOKEN" ]; then
  CSRF_TOKEN=$(ps -p "$PID" -o command= | sed -n 's/.*--csrf_token \([^ ]*\).*/\1/p' || true)
fi

# Find listening TCP ports for the process
PORTS=$(lsof -a -p "$PID" -iTCP -sTCP:LISTEN -F n 2>/dev/null | sed 's/^n\*://; s/^n127.0.0.1://' || true)

for PORT in $PORTS; do
  RESPONSE=$(curl -s -m 2 -X POST "http://127.0.0.1:${PORT}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary" \
    -H "Content-Type: application/json" \
    -H "X-Codeium-Csrf-Token: ${CSRF_TOKEN}" \
    -d "{}" 2>/dev/null || true)
  if echo "$RESPONSE" | grep -q '"response"'; then
    echo "$RESPONSE"
    exit 0
  fi
done

echo '{"status":"fallback","reason":"could not fetch from any port"}'
