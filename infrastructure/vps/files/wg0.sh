#!/usr/bin/env sh

set -e

PRIVATE="$(wg genkey)"
PUBLIC="$1"

# print server public key
echo "$PRIVATE" | wg pubkey

cat > /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = $PRIVATE
Address = 10.0.0.1
# todo necessary?
ListenPort = 51822

[Peer]
PublicKey = $PUBLIC
AllowedIPs = 10.0.0.2
EOF

chmod 022 /etc/wireguard/wg0.conf
