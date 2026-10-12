# Oxlantern escalation runbook

Owner: Tomas Ebbersley
Last reviewed: 2026-08-20

## Purpose

Oxlantern hosts every prod and stg VM. When the problem is below the OS
(hypervisor, storage, network, managed PostgreSQL), we cannot fix it, they
can. This page says how to get them quickly.

## Signals

- Multiple VMs unreachable at once
- Managed PostgreSQL backup job red in Gaugeworks
- Provisioning API (`api.oxlantern.net`) returning 5xx

## Steps

1. Check one VM is really down: ping and ssh from `vpn-prod-01`, not your laptop.
2. Open an urgent ticket on the Oxlantern portal, include host name, DC hall
   (Slough or Amsterdam) and the time you first noticed.
3. Phone the Oxlantern NOC for sev 1. Number is in the vault under
   `oxlantern/noc`, not in this repo.
4. Their on-call SRE reaches us over the site-to-site tunnel to
   `vpn.strikeonecs.io`. If the tunnel is the problem, see vpn-gateway.
5. Post in the team chat #platform so others know.

## Rollback

N/A. If Oxlantern changed something and it made it worse, ask them to revert
and quote the ticket number.

## Contacts

Ravi Teague at Oxlantern is the usual SRE contact (r.teague@oxlantern.net).
Tomas for day-to-day, Priya for contract matters.
