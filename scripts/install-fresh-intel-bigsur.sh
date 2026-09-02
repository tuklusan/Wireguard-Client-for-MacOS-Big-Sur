#!/usr/bin/env bash
# Copyright (c) 2026 Supratim Sanyal of SANYALnet Labs.
# Licensed under the SANYALnet Labs Non-Commercial License; see ../LICENSE.
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
MACPORTS_PKG="$REPO_DIR/artifacts/MacPorts-2.12.3-11-BigSur.pkg"
WIREGUARD_PKG="$REPO_DIR/artifacts/WireGuard-compat-full.pkg"

[ "$(uname -m)" = x86_64 ] || { echo "ERROR: Intel macOS is required." >&2; exit 2; }
OS_VERSION="$(sw_vers -productVersion)"
case "$OS_VERSION" in
    11.*|12.*|13.*|14.*|15.*) ;;
    *) echo "ERROR: supported versions are macOS Big Sur 11 through Sequoia 15." >&2; exit 2 ;;
esac
[ -f "$MACPORTS_PKG" ] && [ -f "$WIREGUARD_PKG" ] || { echo "ERROR: installer artifacts are missing." >&2; exit 2; }

if [[ "$OS_VERSION" == 11.* ]]; then
    if [ ! -x /opt/local/bin/port ]; then sudo installer -pkg "$MACPORTS_PKG" -target /; fi
    sudo /opt/local/bin/port selfupdate
    sudo /opt/local/bin/port install bash
else
    command -v /usr/local/bin/brew >/dev/null 2>&1 || { echo "ERROR: Homebrew is required on macOS 12 through 15." >&2; exit 2; }
    /usr/local/bin/brew install bash
fi
sudo installer -pkg "$WIREGUARD_PKG" -target /

install -m 600 "$REPO_DIR/configs/client-eth-macos-intel.conf.example" "$HOME/client-eth-macos-intel.conf"
install -m 600 "$REPO_DIR/configs/client-wifi-macos-intel.conf.example" "$HOME/client-wifi-macos-intel.conf"
for name in start-wireguard-eth start-wireguard-wifi stop-wireguard-eth stop-wireguard-wifi; do
    install -m 755 "$REPO_DIR/scripts/$name.sh" "$HOME/$name.sh"
done

sudo mkdir -p /usr/local/etc/wireguard
sudo ln -sfn "$HOME/client-eth-macos-intel.conf" /usr/local/etc/wireguard/wg-eth.conf
sudo ln -sfn "$HOME/client-wifi-macos-intel.conf" /usr/local/etc/wireguard/wg-wifi.conf
echo "Install complete. Fill both home-directory configs before starting a tunnel."
