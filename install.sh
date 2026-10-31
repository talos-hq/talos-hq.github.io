#!/bin/sh
# talosbot.ai/install.sh: installs Talos on macOS or Linux.
#   curl -fsSL https://talosbot.ai/install.sh | sh
# The real installer lives in the Talos repo; this shim keeps the short URL stable.
set -eu
exec_url="https://raw.githubusercontent.com/talos-hq/talos/main/slim/install.sh"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$exec_url" -o "$tmp"
sh "$tmp" "$@"
