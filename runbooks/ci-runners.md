# CI runners runbook

Owner: Tomas Ebbersley
Last reviewed: never

## Purpose

`ci.corp.strikeonecs.io` schedules jobs on a pool of runners:
`runner-ci-01` to `runner-ci-06` (10.40.5.11 - .16). Jobs run in Docker.
When the pool is stuck, nobody can merge to anything.

## Signals

- Jobs queued for more than 10 min with idle runners
- Runner shows `offline` on the ci admin page
- Disk full on a runner (docker layers, always docker layers)

## Steps

1. ssh to the runner, `docker system df`.
2. Clean: `docker system prune -af --filter "until=72h"`
   runner-ci-04 fills up fastest (it gets the big image builds), check it
   first. Threshold for panic is 90%.
3. Runner agent stuck: `sudo systemctl restart ci-runner`.
4. If a runner is toast, drain it first (`scripts/runner-drain.sh`) then ask
   Oxlantern to re-image via the provisioning API. Don't just delete it.

TODO: write up autoscaling for the pool, ask Priya if its still wanted

## Rollback

Nothing to roll back for a prune. A re-imaged runner comes back from the
base image, re-register it with the ci admin token (vault, not here).

## Contacts

Tomas. Priya if the whole pool is down.
