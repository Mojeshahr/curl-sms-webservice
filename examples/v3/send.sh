#!/usr/bin/env sh
#
# Send - the simplest send, one text to several numbers over GET.
#
# Fine for a quick trial. In production take SendBulk instead: it keeps the key
# out of the URL and accepts a tracking id of your own per recipient.
#
# Needs curl and jq. Nothing else.
#
#   PAYAM_RESAN_API_KEY=... PAYAM_RESAN_SENDER=... ./examples/v3/send.sh

set -eu

# docs:start
# --data-urlencode encodes exactly once. Encoding the text yourself beforehand
# makes the message arrive full of %D8 sequences.
response=$(curl -sS --max-time 30 --get \
  'https://api.sms-webservice.com/api/V3/Send' \
  --data-urlencode "ApiKey=$PAYAM_RESAN_API_KEY" \
  --data-urlencode "Sender=$PAYAM_RESAN_SENDER" \
  --data-urlencode 'Text=کد تأیید شما ۱۲۳۴۵۶ است' \
  --data-urlencode 'Recipients=9121112222,9121113333')

if [ "$(printf '%s' "$response" | jq -r '.Success')" != "true" ]; then
  printf '%s' "$response" | jq -r '"failed. code \(.ErrorCode): \(.Error)"' >&2
  exit 1
fi

printf '%s' "$response" | jq -r '.Result[] | "id \(.Id)"'
# docs:end
