# VPN gateway

pasted from pathnote 2026-04-06, needs cleanup

Gateway: vpn-prod-00 (10.40.1.10), WireGuard, public name vpn.strikeonecs.io
Config: /etc/wireguard/wg0.conf

Add a peer for staff:
    s1 vpn profile --user firstname.lastname --out ./profile.conf
then send it over the team chat DM (not a channel!)

Peers dont connect:
- check `wg show` on the box, latest handshake
- check udp 51820 is open on the oxlantern firewall
- restart: systemctl restart wg-quick@wg0

Vendor accounts (mossbarrow, wickerlume) are in the vendor group, VLAN limited.
