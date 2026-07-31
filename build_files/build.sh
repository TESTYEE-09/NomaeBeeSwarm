#!/usr/bin/env bash
set -ouex pipefail

NOMAEOS_VERSION="${NOMAEOS_VERSION:-0.1.0}"
NOMAEOS_REVISION="${NOMAEOS_REVISION:-development}"

# Overlay NomaeOS files onto the Bazzite Deck base image.
cp -avf /ctx/system_files/. /

install -d -m 0755 /usr/share/licenses/nomaeos
install -m 0644 /ctx/LICENSE /usr/share/licenses/nomaeos/LICENSE
install -m 0644 /ctx/NOTICE.md /usr/share/licenses/nomaeos/NOTICE.md

chmod 0755 /usr/libexec/nomaeos/enable-controller-wake
chmod 0755 /usr/libexec/nomaeos/apply-branding
chmod 0755 /usr/bin/nomae-box-info

# Keep Bazzite's ID, VARIANT and VARIANT_ID untouched for compatibility.
# Only the user-facing name and NomaeOS-specific metadata are changed.
if [[ -f /usr/lib/os-release ]]; then
  sed -i 's/^NAME=.*/NAME="NomaeOS"/' /usr/lib/os-release
  sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="NomaeOS 1 (Bazzite-based)"/' /usr/lib/os-release
  sed -i 's/^HOME_URL=.*/HOME_URL="https:\/\/github.com\/TESTYEE-09\/NomaeOS"/' /usr/lib/os-release
  sed -i 's/^DOCUMENTATION_URL=.*/DOCUMENTATION_URL="https:\/\/github.com\/TESTYEE-09\/NomaeOS#readme"/' /usr/lib/os-release || true
  sed -i '/^NOMAEOS_/d' /usr/lib/os-release
  {
    echo "NOMAEOS_VERSION=${NOMAEOS_VERSION}"
    echo "NOMAEOS_REVISION=${NOMAEOS_REVISION}"
    echo 'NOMAEOS_DEVICE="Nomae Box"'
  } >> /usr/lib/os-release
fi

cat > /etc/nomaeos-release <<EOF
NOMAEOS_NAME="NomaeOS"
NOMAEOS_VERSION="${NOMAEOS_VERSION}"
NOMAEOS_REVISION="${NOMAEOS_REVISION}"
NOMAEOS_DEVICE="Nomae Box"
NOMAEOS_CHASSIS="Jonsbo C6"
NOMAEOS_BASE="Bazzite Deck"
EOF

printf 'nomae-box\n' > /etc/hostname
systemctl enable nomae-controller-wake.service

install -d -m 0755 /usr/share/backgrounds
ln -sfn /usr/share/wallpapers/NomaeOS/contents/images/3840x2160.svg /usr/share/backgrounds/nomaeos.svg

test -x /usr/libexec/nomaeos/enable-controller-wake
test -x /usr/libexec/nomaeos/apply-branding
test -x /usr/bin/nomae-box-info
test -f /usr/share/nomaeos/hardware/nomae-box-c6.json
test -f /usr/share/wallpapers/NomaeOS/contents/images/3840x2160.svg
test -f /etc/xdg/autostart/nomaeos-branding.desktop

dnf5 clean all
