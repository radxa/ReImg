# ReImg Recovery System

## Development dependency for non NixOS

`nixos-generators` is needed to build the final image. Below is a quick guide:

First, install [`nix`](https://nix.dev/tutorials/install-nix) and [enable flakes](https://nixos.wiki/wiki/Flakes). Then:

```
# Install nixos-generators
nix profile install github:nix-community/nixos-generators
```

## Development tool

We included `reimg` developer tool to simplify common tasks. Please run it without any command to see the help content.
