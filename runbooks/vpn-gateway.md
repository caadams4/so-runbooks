# VPN gateway runbook

Owner: Tomas Ebbersley
Last reviewed: 2026-11-06

## Purpose

WireGuard gateway for staff and vendor access. Public name
`vpn.strikeonecs.io`, since 12 Oct 2026 a pair: `vpn-prod-01` (10.40.1.11) and
`vpn-prod-02` (10.40.1.12), both at Oxlantern Slough. The old single box
`vpn-prod-00` is powered off but kept until the end of November. Mossbarrow and Wickerlume engineers use named vendor
accounts, limited to the office-network VLANs. Oxlantern on-call comes in
over the site-to-site tunnel.

## Signals

- Gaugeworks `vpn-peers` panel drops to 0 or flatlines
- Staff report "connected but nothing loads" (usually MTU, see below)
- `status.strikeonecs.io` does not cover VPN, so nobody will tell you. Check.

## Steps

1. On `vpn-prod-01` and `-02`: `sudo wg show`. Look at `latest handshake` per peer.
   Everything older than ~3 min while the user claims to be connected is dead.
2. Check udp/51820 is reachable from outside: `scripts/check-vpn-peers.sh`
   (needs `VPN_HOST` set, see `.env.example`).
3. Restart: `sudo systemctl restart wg-quick@wg0`, one box at a time. Peers
   reconnect on their own within ~30s. Never restart both together.
4. New staff profile: `s1 vpn profile --user firstname.lastname --out ./profile.conf`
   and send over a DM, never a channel.
5. Bristol 3rd floor moved over the weekend of 17/18 Oct (Mossbarrow did the
   cabling). If Mossbarrow vendor peers cannot reach the new VLAN, check
   their AllowedIPs, not the gateway.
6. Vendor accounts live in the `vendor` peer group. Do not widen their
   AllowedIPs, ask Corporate IT first.

7. "Connected but nothing loads" is MTU. New gateways want `MTU = 1380` in
   the client profile, `s1 vpn profile` sets it, old hand-made profiles dont.

## Rollback

Config is in `/etc/wireguard/wg0.conf`, previous copy is `wg0.conf.bak`.
`cp wg0.conf.bak wg0.conf && systemctl restart wg-quick@wg0`.

To back out the whole October move: power `vpn-prod-00` back on and point
the `vpn.strikeonecs.io` record at 10.40.1.10 (ttl is 60s). Only possible
until end of Nov.

## Contacts

Tomas, then Priya. Oxlantern on-call for tunnel problems. Oxlantern on-call for network-level problems (see
oxlantern-escalation).
