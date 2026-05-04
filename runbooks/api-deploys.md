# API deploys runbook

Owner: Tomas Ebbersley
Last reviewed: never

## Purpose

How to ship the client-facing engagement API (`api.strikeonecs.io`) with
`s1 deploy`. Two app hosts, `api-prod-01` and `api-prod-02`, behind the load
balancer. Currently serves `/v1/engagements` only.

## Signals

- Gaugeworks `api-latency` p95 over 800ms for 5 min
- 5xx rate over 1%
- Tallyhook posts a failed deploy to the team chat

## Steps

1. Tag the release `vYYYY.MM.N` on `git.corp.strikeonecs.io`.
2. `s1 deploy api --env stg --tag vYYYY.MM.N`, run `scripts/api-health.sh`.
3. **CONFIRM** with a second engineer, then
   `s1 deploy api --env prod --tag vYYYY.MM.N --rolling`.
4. Watch the 5xx panel for 10 minutes.

## Rollback

`s1 deploy api --env prod --tag <previous tag> --rolling`. Migrations are
forward-only, if the release had one, talk to Priya before rolling back.

## Contacts

Tomas, Priya.
