#!/bin/bash
set -e

# Start OpenVPN in foreground (so we can see logs)
openvpn --config /vpn/vpn.conf &
OVPN_PID=$!

# Wait for tun0
echo "Waiting for tun0 interface..."
while ! ip addr show tun0 > /dev/null 2>&1; do
    sleep 1
done
echo "tun0 is up"

# Start HAProxy in foreground
haproxy -f /usr/local/etc/haproxy/haproxy.cfg &

# Wait on OpenVPN
wait $OVPN_PID
