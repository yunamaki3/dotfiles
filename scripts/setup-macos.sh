#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_config() {
  local name="$1"
  local source="$2"
  local target="$config_dir/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/$name"
  fi
  ln -sfn "$source" "$target"
}

mkdir -p "$config_dir"
link_config wezterm "$repo_dir/.config/wezterm"
link_config nvim "$repo_dir/.config/nvim"
ln -sfn "$repo_dir/.config/starship.toml" "$config_dir/starship.toml"

if ! grep -q 'starship init zsh' "$HOME/.zshrc" 2>/dev/null; then
  printf '\neval "$(starship init zsh)"\n' >> "$HOME/.zshrc"
fi

printf 'Config links installed. Install packages with:\n'
printf '  brew install neovim starship ripgrep fd fzf llvm node\n'
printf '  brew install --cask font-fira-mono-nerd-font font-noto-sans-cjk\n'

