#!/usr/bin/env sh
#
# SendTokenSingle - send a template to one number, with a JSON body.
#
# The usual path for a one-time password. There is no sender input; the service
# takes it from the template. Prefer this POST variant over the GET one: with
# GET both the account key and the code itself end up in the URL and in the web
# server log.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/send-token-single.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/SendTokenSingle' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "TemplateKey": "verifycode",
  "Destination": 9121112222,
  "p1": "123456"
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

# This method takes no UserTraceId, so it comes back null. If you need a
# tracking id, SendTokenMulti works even for a single recipient.
printf '%s' "$response" | jq -r '.Result[] | "id \(.Id) from line \(.Sender)", "final text: \(.FinalText)"'
# docs:end
