# PostgreSQL failover

from pathnote. pg 14 right now, oxlantern says upgrade to 16 is planned for later

primary: pg-prod-01  replica: pg-prod-02  (10.40.3.21 / 10.40.3.22)
staging: pg-stg-01 / pg-stg-02

Check replication:
    psql -h pg-prod-02 -c "select now() - pg_last_xact_replay_timestamp() as lag;"

Promote replica (primary is really dead, not just slow):
    ssh pg-prod-02
    sudo -u postgres pg_ctl promote -D /var/lib/postgresql/14/main

then repoint pgbouncer on api-prod-01/02 (see api deploys) and tell #platform in the team chat.
Old primary must NOT ever come back as primary. rebuild it from the new one.

## pg 16 upgrade (wip)

oxlantern doing 14 -> 16 for managed customers, stg first (aug), prod after.
paths below change to /16/ after. dont trust the promote cmd until i retest
