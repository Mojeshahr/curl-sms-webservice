#!/usr/bin/env sh
#
# StatusById - message status by the ids the sending method returned.
#
# Ask in batches, not one at a time. Leave more than a few minutes between
# calls or you will hit error 20.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/status-by-id.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/StatusById' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "Ids": [9903211, 9903212]
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

# Branch on StatusCode, never on the Status text. These five codes mean the
# message is still on its way: ask again later rather than sending again.
printf '%s' "$response" | jq -r '
  .Result[]
  | "\(.Id): \(.Status)\(if .StatusCode | IN(0,1,2,3,10) then " (ask again later)" else "" end)"'
# docs:end
