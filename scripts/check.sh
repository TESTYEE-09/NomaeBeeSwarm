#!/usr/bin/env bash
set -euo pipefail

required=(
  Containerfile
  build_files/build.sh
  system_files/etc/nomaeos/controller-wake.conf
  system_files/etc/xdg/autostart/nomaeos-branding.desktop
  system_files/usr/libexec/nomaeos/enable-controller-wake
  system_files/usr/libexec/nomaeos/apply-branding
  system_files/usr/lib/systemd/system/nomae-controller-wake.service
  system_files/usr/share/nomaeos/hardware/nomae-box-c6.json
  system_files/usr/share/wallpapers/NomaeOS/contents/images/3840x2160.svg
)

for file in "${required[@]}"; do
  [[ -s "$file" ]] || { echo "Missing required file: $file" >&2; exit 1; }
done

bash -n build_files/build.sh
bash -n system_files/usr/libexec/nomaeos/enable-controller-wake
bash -n system_files/usr/libexec/nomaeos/apply-branding
bash -n system_files/usr/bin/nomae-box-info

grep -q 'ghcr.io/ublue-os/bazzite-deck:stable' Containerfile
grep -q 'Jonsbo C6' system_files/usr/share/nomaeos/hardware/nomae-box-c6.json
grep -q 'GameSir Nova Lite' system_files/usr/share/nomaeos/hardware/nomae-box-c6.json
grep -q 'Keep Bazzite.*VARIANT' build_files/build.sh

python3 -m json.tool system_files/usr/share/nomaeos/hardware/nomae-box-c6.json >/dev/null
python3 -m json.tool system_files/usr/share/wallpapers/NomaeOS/metadata.json >/dev/null

echo "NomaeOS repository checks passed"
