#!/usr/bin/env sh
#
# GetInbox - the messages people have sent to your account's lines.
#
# This is a poll, not a webhook: the service pushes nothing to your server, so
# call it periodically yourself. Leave more than a few minutes between calls or
# you will hit error 20.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/get-inbox.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/GetInbox' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY"
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

# The sender field is called Form in the service itself, not From.
printf '%s' "$response" | jq -r '.Result[] | "\(.Time)  \(.Form) -> \(.To): \(.Text)"'
# docs:end
