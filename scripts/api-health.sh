#!/usr/bin/env bash
# quick smoke test against an api env. API_BASE_URL e.g. the stg or prod base
set -euo pipefail
: "${API_BASE_URL:?set API_BASE_URL}"
for path in /v1/engagements /healthz; do
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$API_BASE_URL$path")
  echo "$path -> $code"
  [ "$code" = "200" ] || [ "$code" = "401" ] || exit 1
done
