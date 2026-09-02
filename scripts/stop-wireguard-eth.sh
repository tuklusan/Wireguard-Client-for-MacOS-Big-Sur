#!/usr/bin/env bash
# Copyright (c) 2026 Supratim Sanyal of SANYALnet Labs.
# Licensed under the SANYALnet Labs Non-Commercial License; see ../LICENSE.
set -u
BASH4=/opt/local/bin/bash
[[ -x "$BASH4" ]] || BASH4=/usr/local/bin/bash
sudo "$BASH4" /usr/local/bin/wg-quick down wg-eth
