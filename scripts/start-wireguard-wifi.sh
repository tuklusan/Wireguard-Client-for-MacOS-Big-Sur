#!/usr/bin/env bash
# Copyright (c) 2026 Supratim Sanyal of SANYALnet Labs.
# Licensed under the SANYALnet Labs Non-Commercial License; see ../LICENSE.
set -u
CONFIG=wg-wifi
SOURCE_CONFIG="$HOME/client-wifi-macos-intel.conf"
TARGET="${WIREGUARD_SERVER_PROBE_ADDRESS:-}"
BASH4=/opt/local/bin/bash
WGQUICK=/usr/local/bin/wg-quick

if [[ ! -x "$BASH4" && -x /usr/local/bin/bash ]]; then BASH4=/usr/local/bin/bash; fi
[[ -x "$BASH4" ]] || { echo "ERROR: Bash 4+ is required." >&2; exit 2; }
[[ -f "$SOURCE_CONFIG" ]] || { echo "ERROR: missing $SOURCE_CONFIG." >&2; exit 2; }
[[ -n "$TARGET" ]] || { echo "ERROR: set WIREGUARD_SERVER_PROBE_ADDRESS first." >&2; exit 2; }
grep -q 'REPLACE_WITH_' "$SOURCE_CONFIG" && { echo "ERROR: replace all config placeholders first." >&2; exit 2; }

sudo chmod 600 "$SOURCE_CONFIG"
sudo "$BASH4" "$WGQUICK" up "$CONFIG"
trap 'sudo "$BASH4" "$WGQUICK" down "$CONFIG" >/dev/null 2>&1 || true' EXIT
sleep 3
WG_INTERFACE="$(sudo /usr/local/bin/wg show interfaces | awk '{print $NF}')"
[[ -n "$WG_INTERFACE" ]] || { echo "ERROR: no active WireGuard interface." >&2; exit 1; }
read -r rx0 tx0 < <(sudo /usr/local/bin/wg show "$WG_INTERFACE" transfer | awk '{rx += $2; tx += $3} END {print rx + 0, tx + 0}')
ping -c 3 -W 1 "$TARGET" >/tmp/wireguard-wifi-connectivity.log 2>&1; ping_rc=$?
read -r rx1 tx1 < <(sudo /usr/local/bin/wg show "$WG_INTERFACE" transfer | awk '{rx += $2; tx += $3} END {print rx + 0, tx + 0}')
if (( ping_rc == 0 && rx1 > rx0 && tx1 > tx0 )); then
    echo "WireGuard wifi verified: RX $rx0 -> $rx1, TX $tx0 -> $tx1 bytes."
    exit 0
fi
echo "ERROR: verification failed; RX $rx0 -> $rx1, TX $tx0 -> $tx1; ping exit $ping_rc." >&2
cat /tmp/wireguard-wifi-connectivity.log >&2
exit 1
