#!/usr/bin/env bash
set -euo pipefail

required=(
  Containerfile
  build_files/build.sh
  system_files/etc/nomaeos/controller-wake.conf
  system_files/usr/libexec/nomaeos/enable-controller-wake
  system_files/usr/share/nomaeos/hardware/nomae-box-c6.json
)

for file in "${required[@]}"; do
  test -s "$file" || { echo "Missing build-context file: $file" >&2; exit 1; }
done

echo "NomaeOS Docker build context is complete"
