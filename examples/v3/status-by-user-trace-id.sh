#!/usr/bin/env sh
#
# StatusByUserTraceId - message status by the ids you assigned yourself.
#
# Make UserTraceId the key of your own database row and you never need to store
# the service's id. This method is also the safe way to detect a duplicate send:
# after a dropped connection, ask here first whether the message was registered.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/status-by-user-trace-id.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/StatusByUserTraceId' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY",
  "UserTraceIds": [1001, 1002]
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

# Code 8 means the id is not in your account. After a timeout that means the
# send was never registered and you can safely send it again.
printf '%s' "$response" | jq -r '
  .Result[]
  | "\(.UserTraceId): \(if .StatusCode == 8 then "not registered" else .Status end)"'
# docs:end
