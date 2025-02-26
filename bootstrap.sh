#! /bin/zsh

set -euo pipefail

echo "=================================="
echo "Welcome to nunu MacOS bootstrapper"
echo "=================================="

if [ "$(uname)" != "Darwin" ]; then
  echo "This script is only for Mac OS X"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Error: hostname argument is required"
  echo "Usage: $0 <hostname>"
  exit 1
fi

hostname="$1"

echo "Installing Nix (Lix)"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Activating minimal nix configuration"

NAME="$hostname" nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/nix-darwin-24.11#darwin-rebuild -- \
  switch --impure --flake "github:nunu-ai/macos-bootstrap#$hostname"

echo "Bootstrap complete. Make sure you follow the remaining setup steps."
