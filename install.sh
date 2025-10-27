#!/usr/bin/env bash

USER_HOME=$(eval echo ~$SUDO_USER)
DIR="$USER_HOME/joaov"

sudo nixos-generate-config --show-hardware-config > "$DIR/hosts/default/hardware-configuration.nix" || { echo "Failed to generate hardware configuration"; exit 1; }

cd "$USER_HOME" || { echo "Failed to cd to home directory"; exit 1; }

cd "$DIR" || { echo "Failed to cd to $DIR"; exit 1; }

sudo nixos-rebuild switch --flake .#default || { echo "Failed to rebuild NixOS configuration"; exit 1; }

echo "Script completed successfully."
