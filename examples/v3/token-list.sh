#!/usr/bin/env sh
#
# TokenList - the account's templates, with their key, text and approval state.
#
# Use it to find the TemplateKey the template sending methods need. Like
# AccountInfo, this method is exempt from the credit check.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... ./examples/v3/token-list.sh

set -eu

# docs:start
response=$(curl -sS --max-time 30 \
  -X POST 'https://api.sms-webservice.com/api/V3/TokenList' \
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

printf '%s' "$response" | jq -r '
  .Result[]
  | "\(.Key) (\(if .Status == 2 then "sendable" else "not sendable" end)): \(.TextTemplate)"'
# docs:end
