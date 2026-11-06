# PostgreSQL failover runbook

Owner: Tomas Ebbersley
Last reviewed: 2026-11-06

## Purpose

Production PostgreSQL 16 pair: `pg-prod-01` (primary, 10.40.3.21) and
`pg-prod-02` (replica, 10.40.3.22). Staging pair is `pg-stg-01` / `pg-stg-02`.
The engagement API, Strikeboard and Ledgerline all read from here. Upgraded
from 14 to 16 in the window on Sat 5 Sep 2026.

## Signals

- Gaugeworks `pg-replication-lag` over 30s for 5 min
- API 5xx with `connection refused` or `could not connect to server`
- Oxlantern backup job red

## Steps

1. Check lag: `scripts/pg-replica-lag.sh` (needs `PGHOST_REPLICA`).
2. Decide: is the primary really dead, or just slow? If slow, do not promote.
   Get Oxlantern involved first (oxlantern-escalation). **CONFIRM** with
   Priya before promoting prod.
3. Promote on `pg-prod-02`:
   `sudo -u postgres /usr/lib/postgresql/16/bin/pg_ctl promote -D /var/lib/postgresql/16/main`
4. Repoint pgbouncer on `api-prod-01` and `api-prod-02` to the new primary,
   `sudo systemctl reload pgbouncer`.
5. Post in the team chat #platform.
6. Old primary must never come back as primary. Rebuild it from the new one
   with `pg_basebackup`.

## Rollback

There is no un-promote. If you promoted by mistake, treat the old primary as
the replica to rebuild and fail over properly in a quiet window.

## Contacts

Tomas, Priya. Oxlantern managed PostgreSQL support for storage issues.
