#!/usr/bin/env sh
#
# AccountInfo - the account's remaining credit and its active sender lines.
#
# The lightest method in the service and the best way to test a key: it sends
# nothing, spends no credit, and answers even on a zero balance.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/account-info.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/AccountInfo' \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d @- <<JSON
{
  "ApiKey": "$PAYAM_RESAN_API_KEY"
}
JSON
)

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s\n' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

printf '%s\n' "$response" | jq -r '"credit: \(.Result.Credit)"'
printf '%s\n' "$response" | jq -r '.Result.AvailableSenders[] | "line: \(.)"'
# docs:end
