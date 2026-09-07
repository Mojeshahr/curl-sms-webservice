#!/usr/bin/env sh
#
# SendBulk - one text to many recipients, each with a tracking id of your own.
#
# The recommended way to send in production. The key travels in the request
# body rather than the URL, and each recipient takes a UserTraceId so delivery
# reports can be matched without storing the service's own id.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... PAYAM_RESAN_SENDER=... ./examples/v3/send-bulk.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/SendBulk' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "Sender": $PAYAM_RESAN_SENDER,
  "Text": "سفارش شما ثبت شد.",
  "Recipients": [
    { "Destination": 9121112222, "UserTraceId": 1001 },
    { "Destination": 9121113333, "UserTraceId": 1002 }
  ]
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

printf '%s' "$response" | jq -r '.Result[] | "\(.UserTraceId) => id \(.Id)"'
# docs:end
