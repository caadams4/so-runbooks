#!/usr/bin/env bash
# print replication lag on the replica, exit 1 if over MAX_LAG seconds
# needs PGHOST_REPLICA, PGUSER, PGDATABASE in env (PGPASSWORD via ~/.pgpass)
set -euo pipefail
MAX_LAG="${MAX_LAG:-30}"
: "${PGHOST_REPLICA:?set PGHOST_REPLICA}"
lag=$(psql -h "$PGHOST_REPLICA" -At -c \
  "select coalesce(extract(epoch from now() - pg_last_xact_replay_timestamp()),0)::int")
echo "replica lag: ${lag}s"
[ "$lag" -le "$MAX_LAG" ]
