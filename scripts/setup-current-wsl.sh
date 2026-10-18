#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_dir/profiles/windows-wsl"
target_home="${DOTFILES_TARGET_HOME:-$HOME}"
config_dir="${XDG_CONFIG_HOME:-$target_home/.config}"
backup_dir="$target_home/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"
dry_run=false
case "${1:-}" in
  --dry-run) dry_run=true ;;
  '') ;;
  *) printf 'Usage: bash scripts/setup-current-wsl.sh [--dry-run]\n' >&2; exit 2 ;;
esac
[[ -n "${WSL_DISTRO_NAME:-}" ]] || { echo 'Run this in WSL Ubuntu.' >&2; exit 1; }
[[ $target_home = /* && $target_home != / ]] || { echo 'Target home must be an absolute non-root path.' >&2; exit 1; }

install_copy() {
  local src="$1" dst="$2" label="$3"
  [[ -e "$src" ]] || { echo "Missing source: $src" >&2; exit 1; }
  printf '%s -> %s\n' "$src" "$dst"
  $dry_run && return 0
  mkdir -p -- "$(dirname -- "$dst")"
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p -- "$backup_dir"
    mv -- "$dst" "$backup_dir/$label"
  fi
  cp -R -- "$src" "$dst"
}

install_copy "$source_dir/nvim" "$config_dir/nvim" nvim
install_copy "$source_dir/starship.toml" "$config_dir/starship.toml" starship.toml
install_copy "$source_dir/shell/zshrc" "$target_home/.zshrc" zshrc
install_copy "$source_dir/shell/bashrc" "$target_home/.bashrc" bashrc
install_copy "$source_dir/shell/profile" "$target_home/.profile" profile
$dry_run && exit 0
mkdir -p -- "$target_home/.vsnip"
printf '\nInstalled. Previous configs (if any): %s\n' "$backup_dir"
printf 'Run: bash scripts/install-current-wsl-deps.sh\nThen: exec zsh\nThen: nvim --headless "+Lazy! restore" +qa\n'
printf 'After git pull, rerun setup to apply updates. Existing .zshrc.local is preserved.\n'
