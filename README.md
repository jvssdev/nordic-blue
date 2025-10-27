## Requirements

- You must be running on NixOS.
- The nordic-blue folder is expected to be in your home directory.
- Must have installed using GPT & UEFI. Grub is what is supported.
- Manually editing your host specific files. The host is the specific computer your installing on.

### Install

Ensure Git & Vim are installed:

```
nix-shell -p git vim
```

Clone this repo & enter it:

```
git clone https://github.com/jvssdev/nordic-blue
cd nordic-blue
```

Create the host folder for your machine(s)

```
cp -r hosts/default hosts/<your-desired-hostname>
```

**Edit options.nix**

Generate your hardware.nix:

```
nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware-configuration.nix
```

- _Replace all the instances of the name "joaov" with your name_

Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:

```
NIX_CONFIG="experimental-features = nix-command flakes"
sudo nixos-rebuild switch --flake .#hostname
```

Now when you want to rebuild the configuration you can execute the last command, that will rebuild the flake.
