#!/usr/bin/env bash
# usage: runner-drain.sh runner-ci-04
# stops the runner taking new jobs, waits for running ones to finish
set -euo pipefail
host="${1:?usage: $0 <runner-host>}"
ssh "$host" 'sudo touch /etc/ci-runner/drain'
echo "drain flag set on $host, waiting for jobs..."
while ssh "$host" 'pgrep -f ci-job >/dev/null'; do
  sleep 15
done
echo "$host is idle"
