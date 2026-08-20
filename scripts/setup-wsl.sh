#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${WSL_DISTRO_NAME:-}" ]]; then
  printf 'This script is intended for WSL.\n' >&2
  exit 1
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$config_dir"
for name in nvim; do
  target="$config_dir/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/$name"
  fi
  ln -sfn "$repo_dir/.config/$name" "$target"
done
ln -sfn "$repo_dir/.config/starship.toml" "$config_dir/starship.toml"

if ! grep -q 'starship init zsh' "$HOME/.zshrc" 2>/dev/null; then
  printf '\neval "$(starship init zsh)"\n' >> "$HOME/.zshrc"
fi

printf 'WSL config links installed. Install Neovim 0.11+, git, clang, ripgrep, fd, node and starship.\n'

