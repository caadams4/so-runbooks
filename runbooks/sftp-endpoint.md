# SFTP endpoint runbook

Owner: Tomas Ebbersley
Last reviewed: never

## Purpose

`sftp.strikeonecs.io` is the managed file-transfer endpoint. People & Payroll
use it for the monthly Drovewell exchange: they drop encrypted payroll files
on Drovewell's side by the 18th, and Drovewell posts validation receipts back
to our endpoint. Client data drops also land here.

## Signals

- Receipt missing after a payroll drop (People & Payroll will ask)
- `sftp-prod-01` disk over 80% in Gaugeworks
- Login failures for the Drovewell account

## Steps

1. Host is `sftp-prod-01` (10.40.4.15). `sudo systemctl status sshd-sftp`.
2. Receipts land in `/srv/sftp/drovewell/in/`. List with
   `ls -lt /srv/sftp/drovewell/in | head`.
3. Check the chroot is intact: `scripts/sftp-check.sh` (needs `SFTP_HOST`).
4. Disk: files older than 90 days get archived by cron, if the cron died run
   `sudo /usr/local/bin/sftp-archive`.
5. Keys for external parties are in `/etc/ssh/sftp_keys/`. **CONFIRM** with
   People & Payroll before adding or removing one.

6. Drovewell schema v5 is mandatory from 1 July. Files that fail validation
   come back with a `.rej` receipt, People & Payroll fix the CSV, not us.

## Rollback

No real rollback for a bad key change, put the previous `authorized_keys`
file back from `/etc/ssh/sftp_keys/.prev/`.

## Contacts

People & Payroll (payroll-ops queue on the ticket desk) for anything about
file contents. Tomas for the box.
