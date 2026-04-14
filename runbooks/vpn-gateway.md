# VPN gateway runbook

Owner: Tomas Ebbersley
Last reviewed: never

## Purpose

WireGuard gateway for staff and vendor access. Public name
`vpn.strikeonecs.io`, currently one box: `vpn-prod-00` (10.40.1.10) at
Oxlantern Slough. Mossbarrow and Wickerlume engineers use named vendor
accounts, limited to the office-network VLANs. Oxlantern on-call comes in
over the site-to-site tunnel.

## Signals

- Gaugeworks `vpn-peers` panel drops to 0 or flatlines
- Staff report "connected but nothing loads" (usually MTU, see below)
- `status.strikeonecs.io` does not cover VPN, so nobody will tell you. Check.

## Steps

1. On `vpn-prod-00`: `sudo wg show`. Look at `latest handshake` per peer.
   Everything older than ~3 min while the user claims to be connected is dead.
2. Check udp/51820 is reachable from outside: `scripts/check-vpn-peers.sh`
   (needs `VPN_HOST` set, see `.env.example`).
3. Restart: `sudo systemctl restart wg-quick@wg0`. Peers reconnect on their own
   within ~30s.
4. New staff profile: `s1 vpn profile --user firstname.lastname --out ./profile.conf`
   and send over a DM, never a channel.
5. Vendor accounts live in the `vendor` peer group. Do not widen their
   AllowedIPs, ask Corporate IT first.

## Rollback

Config is in `/etc/wireguard/wg0.conf`, previous copy is `wg0.conf.bak`.
`cp wg0.conf.bak wg0.conf && systemctl restart wg-quick@wg0`.

## Contacts

Tomas, then Priya. Oxlantern on-call for network-level problems (see
oxlantern-escalation once it exists).
