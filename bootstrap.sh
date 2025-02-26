#! /bin/sh

echo "=================================="
echo "Welcome to nunu MacOS bootstrapper"
echo "=================================="

if [ "$(uname)" != "Darwin" ]; then
  echo "This script is only for Mac OS X"
  exit 1
fi

echo "Installing Nix (Lix)"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Activating minimal nix configuration"

hostname=""
while [ "$hostname" == "" ]; do
  echo "Enter the desired hostname: "
  read hostname
  if [ "$hostname" == "" ]; then
    echo "Hostname is required."
  fi
done

NAME="$hostname" nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/nix-darwin-24.11#darwin-rebuild -- \
  switch --impure --flake "github:nunu-ai/macos-bootstrap#$hostname"

echo "Bootstrap complete. Make sure you follow the remaining setup steps."

