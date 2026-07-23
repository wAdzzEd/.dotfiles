#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

for script in "$ROOT/bootstrap.d"/*.sh; do
    echo
    echo "==> $(basename "$script")"
    bash "$script"
done
