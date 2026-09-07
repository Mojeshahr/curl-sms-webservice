#!/usr/bin/env sh
#
# SendTokenSingle over GET - the same template send, with the input in the URL.
#
# Handy for a manual trial, wrong for production: with GET both the account key
# and the one-time code sit in the URL, and they are written to the web server
# log and the Referer header. Take the POST variant instead.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/send-token-single-get.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 --get \
  'https://api.sms-webservice.com/api/V3/SendTokenSingle' \
  --data-urlencode "ApiKey=$PAYAM_RESAN_API_KEY" \
  --data-urlencode 'TemplateKey=verifycode' \
  --data-urlencode 'Destination=9121112222' \
  --data-urlencode 'p1=123456')

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

printf '%s' "$response" | jq -r '.Result[] | "id \(.Id), final text: \(.FinalText)"'
# docs:end
