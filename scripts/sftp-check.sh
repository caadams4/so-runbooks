#!/usr/bin/env bash
# check sftp endpoint answers and list newest receipts
# needs SFTP_HOST, key via ssh-agent
set -euo pipefail
: "${SFTP_HOST:?set SFTP_HOST}"
nc -z -w 5 "$SFTP_HOST" 22 && echo "port 22 ok"
echo "newest receipts:"
echo "ls -lt drovewell/in" | sftp -q -b - "$SFTP_HOST" | head -n 6
