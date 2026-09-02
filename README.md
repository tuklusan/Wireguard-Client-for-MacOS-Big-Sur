# WireGuard Client for Intel macOS Big Sur through Sequoia

Reusable Intel macOS Big Sur materials for two independently configured
WireGuard client tunnels. The project is maintained by Supratim Sanyal of
SANYALnet Labs.

> **Compatibility tested: Intel macOS Big Sur 11.7.11 and Intel macOS Sequoia
> 15.7.9.** Based on successful testing at both endpoints, this client is
> likely to work on Intel versions across this complete range:
>
> - macOS Big Sur 11
> - macOS Monterey 12
> - macOS Ventura 13
> - macOS Sonoma 14
> - macOS Sequoia 15
>
> Intermediate versions are not individually certified; test the target system
> before production use.

Project home: [SANYALnet Labs blog](https://supratim-sanyal.blogspot.com/)

## Scope

This bundle contains pinned installer artifacts, source snapshots, example
client profiles, and start/stop scripts. It targets Intel macOS 11.x and the
Darwin userspace implementation of WireGuard.

The same client materials were also validated on Intel macOS Sequoia 15.7.9.
The tested compatibility span is therefore macOS Big Sur 11, Monterey 12,
Ventura 13, Sonoma 14, and Sequoia 15.

The two example profiles intentionally contain placeholders. Create private
copies in your home directory, then replace every `REPLACE_WITH_...` value
with the values issued by your server. Do not commit private profiles.

## Installation

1. Copy this repository to the Intel Mac running macOS Big Sur 11 through Sequoia 15.
2. Run `scripts/install-fresh-intel-bigsur.sh`. On Big Sur it uses the bundled
   MacPorts package; on Monterey through Sequoia it requires Homebrew for Bash.
3. Edit `~/client-eth-macos-intel.conf` and
   `~/client-wifi-macos-intel.conf` with the separate client credentials.
4. Set `WIREGUARD_SERVER_PROBE_ADDRESS` to the tunnel gateway address.
5. Run one start script at a time with the installed Bash 4+ path, normally
   `/opt/local/bin/bash` on Big Sur or `/usr/local/bin/bash` on newer Intel macOS.

Each start script uses `wg show <interface> transfer` directly. It requires a
successful probe and increases in both WireGuard RX and TX byte counters. The
script tears the tunnel down automatically after the check; use the matching
stop script for an explicit disconnect.

## Local validation record

On 2026-09-02, the reference Intel Big Sur host ran each tunnel alone for 20
seconds, then disconnected it. The measurements came directly from
`wg show <interface> transfer`, not from network interface counters:

- Ethernet: RX `51,076 -> 183,956`; TX `9,632 -> 26,252`; handshake present.
- Wi-Fi: RX `1,772 -> 9,580`; TX `1,732 -> 3,972`; handshake present.

These results validate the supplied client materials against the configured
server at that time. They do not claim that a new server configuration remains
unchanged.

The manual runner validation also passed on 2026-09-02 using `macos-15-intel`
(macOS 15.7.9). The sequential direct-counter results were:

- Ethernet: RX `92 -> 1,289,580`; TX `456,976 -> 485,952`.
- Wi-Fi: RX `92 -> 101,240`; TX `872,048 -> 896,876`.

Both tunnels were disconnected by the workflow cleanup.

## Pinned materials

- MacPorts base package for Intel Big Sur
- WireGuard compatibility package
- MacPorts Bash archive for Darwin 20 Intel
- `wireguard-go` 0.0.20220316 source snapshot
- `wireguard-tools` v1.0.20210914 source snapshot

SHA-256 values are recorded in `checksums/SHA256SUMS`.

## Official upstream

- [wireguard-go](https://git.zx2c4.com/wireguard-go/)
- [wireguard-tools](https://git.zx2c4.com/wireguard-tools/)

The source archives are retained for reproducible local builds. Their original
upstream license files remain inside the archives.

## Publication gate

Run `scripts/public-gate.sh` before every commit and push. It checks the exact
license hash, rejects private deployment details, and rejects blocked wording
from tracked text files. The mandated license text is checked separately and
kept verbatim.

The optional `runner-validation.yml` workflow repeats the same sequential
counter test on the oldest currently listed standard Intel macOS runner. It
requires encrypted repository secrets named `WG_ETH_CONFIG`, `WG_WIFI_CONFIG`,
`WG_ETH_PROBE`, and `WG_WIFI_PROBE`; profiles are written only to temporary
files and are removed in a final cleanup step. No profile or key is uploaded.

## License and attribution

This project uses the SANYALnet Labs Non-Commercial License in `LICENSE`.
Third-party components retain their own licenses; see
`THIRD_PARTY_NOTICES.md`.
