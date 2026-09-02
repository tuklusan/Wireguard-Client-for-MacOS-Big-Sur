# Upstream Provenance

The two source snapshots in `sources/` correspond to the following official
projects and versions:

The client was tested on Intel macOS Big Sur 11.7.11 and Intel macOS Sequoia
15.7.9. It is therefore likely to work on Intel macOS Big Sur 11, Monterey 12,
Ventura 13, Sonoma 14, and Sequoia 15, although intermediate releases are not
individually certified.

| Component | Version | Official project |
| --- | --- | --- |
| wireguard-go | 0.0.20220316 | https://git.zx2c4.com/wireguard-go/ |
| wireguard-tools | v1.0.20210914 | https://git.zx2c4.com/wireguard-tools/ |

When refreshing either snapshot, record the exact tag or commit and retain its
upstream license file.
