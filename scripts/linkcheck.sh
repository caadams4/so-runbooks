#!/usr/bin/env bash
# check that every relative link in index.md points at a file that exists
set -euo pipefail
cd "$(dirname "$0")/.."
status=0
for target in $(grep -o '](runbooks/[^)]*)' index.md | sed 's/^](//; s/)$//'); do
  if [ ! -f "$target" ]; then
    echo "missing: $target"
    status=1
  fi
done
exit $status
