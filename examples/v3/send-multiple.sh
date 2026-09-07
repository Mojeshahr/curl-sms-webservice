#!/usr/bin/env sh
#
# SendMultiple - a separate text and sender line for each recipient.
#
# For personalised messages that one fixed template cannot cover. Unlike
# SendBulk, Text and Sender are defined per recipient here.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... PAYAM_RESAN_SENDER=... ./examples/v3/send-multiple.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/SendMultiple' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "Recipients": [
    {
      "Sender": $PAYAM_RESAN_SENDER,
      "Destination": 9121112222,
      "Text": "آقای محمدی، سفارش شما ارسال شد.",
      "UserTraceId": 1001
    },
    {
      "Sender": $PAYAM_RESAN_SENDER,
      "Destination": 9121113333,
      "Text": "خانم رضایی، سفارش شما ارسال شد.",
      "UserTraceId": 1002
    }
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
