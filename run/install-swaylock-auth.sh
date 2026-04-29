#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -ne 0 ]]; then
  printf 'Run as root: sudo %s/install-swaylock-auth.sh\n' "$SCRIPT_DIR" >&2
  exit 1
fi

if [[ ! -f "$SCRIPT_DIR/swaylock.pam" ]]; then
  printf 'Missing file: %s/swaylock.pam\n' "$SCRIPT_DIR" >&2
  exit 1
fi
if [[ ! -f "$SCRIPT_DIR/swaylock-setpass" ]]; then
  printf 'Missing file: %s/swaylock-setpass\n' "$SCRIPT_DIR" >&2
  exit 1
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
if [[ -f /etc/pam.d/swaylock ]]; then
  cp /etc/pam.d/swaylock "/etc/pam.d/swaylock.bak.${TIMESTAMP}"
fi

install -m 0644 -o root -g root "$SCRIPT_DIR/swaylock.pam" /etc/pam.d/swaylock
install -m 0700 -o root -g root "$SCRIPT_DIR/swaylock-setpass" /usr/local/sbin/swaylock-setpass

printf 'Installed:\n'
printf '  - /etc/pam.d/swaylock\n'
printf '  - /usr/local/sbin/swaylock-setpass\n'
printf 'Backup (if existed): /etc/pam.d/swaylock.bak.%s\n' "$TIMESTAMP"
printf '\nNext: sudo /usr/local/sbin/swaylock-setpass <username>\n'
