# My Nix Development Environment

Cross-platform, reproducible development environment using Nix and Home Manager.

## Features

- 🚀 LazyVim configuration
- 🐱 Kitty terminal
- 🔧 Development tools
- 📦 Fully reproducible

## Quick Start

### macOS
```shell
git clone https://github.com/yourusername/nix-config.git ~/.config/nix
cd ~/.config/nix
nix run home-manager -- switch --flake .#darwin
```

### Linux
```shell
git clone https://github.com/yourusername/nix-config.git ~/.config/nix
cd ~/.config/nix
nix run home-manager -- switch --flake .#linux
```

### WSL
```shell
git clone https://github.com/yourusername/nix-config.git ~/.config/nix
cd ~/.config/nix
nix run home-manager -- switch --flake .#wsl
```

## Structure

- `home/common.nix` - Shared configuration
- `home/darwin.nix` - macOS-specific
- `home/linux.nix` - Linux-specific
- `home/wsl.nix` - WSL-specific
- `modules/` - Modular configurations
- `modules/nvim/` - LazyVim configuration

## Updating

```shell
cd ~/.config/nix
nix flake update
home-manager switch --flake .#darwin  # or linux/wsl
```
