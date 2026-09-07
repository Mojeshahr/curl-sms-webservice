#!/usr/bin/env sh
#
# SendTokenMulti - one template, many recipients, different values.
#
# The parameters are an array here, not p1 to p10. The first element goes to
# {1}, the second to {2} and so on: the order comes from the placeholder number,
# not from where it appears in the template text.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/send-token-multi.sh

set -eu

# docs:start
# Example template: "مرسوله شما از {2} تحویل پست شد. بارکد مرسوله پستی: {1}"
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/SendTokenMulti' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "TemplateKey": "postcode",
  "Recipients": [
    {
      "Destination": 9121112222,
      "UserTraceId": 1001,
      "Parameters": ["BARCODE-AAA", "شیراز"]
    },
    {
      "Destination": 9121113333,
      "UserTraceId": 1002,
      "Parameters": ["BARCODE-BBB", "تبریز"]
    }
  ]
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

printf '%s' "$response" | jq -r '.Result[] | "\(.UserTraceId) => \(.FinalText)"'
# docs:end
