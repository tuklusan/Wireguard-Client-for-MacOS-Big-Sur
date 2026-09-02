#!/usr/bin/env bash
# Copyright (c) 2026 Supratim Sanyal of SANYALnet Labs.
# Licensed under the SANYALnet Labs Non-Commercial License; see ../LICENSE.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
LICENSE_HASH=dac0b24bb71563c0eec7c34f3ad07adad8c65f35706ea1f0f8557ea736ffd785
status=0
blocked_re='o''pen''ai|chat''gpt|co''dex|co''pilot|gem''ini|anthr''opic|perplex''ity|artificial''[[:space:]]+intelligence|machine''[[:space:]]+learning|auto''mation|automated''[[:space:]]+agent'
secret_re='harry''seldon|10''\.0''\.0''\.114|sanyalnet-labs''\.duckdns''\.org|/Users/rum''tuk|PrivateKey[[:space:]]*=[[:space:]]*[A-Za-z0-9+/]{43}='

if command -v shasum >/dev/null 2>&1; then actual=$(shasum -a 256 "$ROOT/LICENSE" | awk '{print $1}'); else actual=$(openssl dgst -sha256 "$ROOT/LICENSE" | awk '{print $NF}'); fi
[[ "$actual" = "$LICENSE_HASH" ]] || { echo "ERROR: license text changed." >&2; status=1; }

for path in $(cd "$ROOT" && git ls-files); do
    [ "$path" = LICENSE ] && continue
    file "$ROOT/$path" | grep -q 'text' || continue
    if grep -Eiq "$blocked_re" "$ROOT/$path"; then
        echo "ERROR: blocked wording in $path" >&2
        status=1
    fi
    if grep -Eiq "$secret_re" "$ROOT/$path"; then
        echo "ERROR: secret or private deployment detail in $path" >&2
        status=1
    fi
done
exit "$status"
