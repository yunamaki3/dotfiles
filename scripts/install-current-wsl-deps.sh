#!/usr/bin/env bash
set -euo pipefail
[[ -n "${WSL_DISTRO_NAME:-}" ]] || { echo 'Run this inside WSL Ubuntu.' >&2; exit 1; }
[[ $(id -u) != 0 ]] || { echo 'Run as your normal WSL user (sudo is requested for apt only).' >&2; exit 1; }
case "$(uname -m)" in
  x86_64) nvim_arch=x86_64; starship_arch=x86_64; go_arch=amd64 ;;
  aarch64) nvim_arch=arm64; starship_arch=aarch64; go_arch=arm64 ;;
  *) echo 'Only x86_64 and ARM64 are supported.' >&2; exit 1 ;;
esac
sudo apt-get update
sudo apt-get install -y git curl ca-certificates unzip tar build-essential clangd \
  ripgrep fd-find fzf zsh zsh-autosuggestions nodejs npm python3 python3-venv python3-pip cmake xclip

mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"
work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT
# Pin the versions found on the source PC; do not use Ubuntu's older Neovim.
nvim_version=0.12.3
starship_version=1.26.0
curl --fail --location --retry 3 \
  "https://github.com/neovim/neovim/releases/download/v$nvim_version/nvim-linux-$nvim_arch.tar.gz" \
  -o "$work_dir/nvim.tar.gz"
tar -xzf "$work_dir/nvim.tar.gz" -C "$work_dir"
nvim_target="$HOME/.local/opt/nvim-$nvim_version"
if [[ -e "$nvim_target" || -L "$nvim_target" ]]; then
  mv -- "$nvim_target" "$nvim_target.backup-$(date +%Y%m%d-%H%M%S)-$$"
fi
mv -- "$work_dir/nvim-linux-$nvim_arch" "$nvim_target"
curl --fail --location --retry 3 \
  "https://github.com/starship/starship/releases/download/v$starship_version/starship-$starship_arch-unknown-linux-musl.tar.gz" \
  -o "$work_dir/starship.tar.gz"
tar -xzf "$work_dir/starship.tar.gz" -C "$work_dir" starship
for name in nvim starship fd; do
  if [[ -e "$HOME/.local/bin/$name" || -L "$HOME/.local/bin/$name" ]]; then
    mv -- "$HOME/.local/bin/$name" "$HOME/.local/bin/$name.backup-$(date +%Y%m%d-%H%M%S)-$$"
  fi
done
ln -s "$nvim_target/bin/nvim" "$HOME/.local/bin/nvim"
install -m 755 "$work_dir/starship" "$HOME/.local/bin/starship"
ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
# Keep the JS language server compatible with Ubuntu 24.04's Node 18.
npm install --prefix "$HOME/.local/opt/dotfiles-js-lsp" typescript@5.9.2 typescript-language-server@4.4.1 pyright@1.1.414
export PATH="$HOME/.local/bin:$HOME/.local/opt/dotfiles-js-lsp/node_modules/.bin:$PATH"
# Preserve the source PC's Go completion, format-on-save and F5 workflow.
go_version=1.27.3
curl --fail --location --retry 3 "https://go.dev/dl/go$go_version.linux-$go_arch.tar.gz" -o "$work_dir/go.tar.gz"
tar -xzf "$work_dir/go.tar.gz" -C "$work_dir"
go_target="$HOME/.local/opt/go-$go_version"
if [[ -e "$go_target" || -L "$go_target" ]]; then
  mv -- "$go_target" "$go_target.backup-$(date +%Y%m%d-%H%M%S)-$$"
fi
mv -- "$work_dir/go" "$go_target"
for name in go gofmt gopls; do
  if [[ -e "$HOME/.local/bin/$name" || -L "$HOME/.local/bin/$name" ]]; then
    mv -- "$HOME/.local/bin/$name" "$HOME/.local/bin/$name.backup-$(date +%Y%m%d-%H%M%S)-$$"
  fi
done
ln -s "$go_target/bin/go" "$HOME/.local/bin/go"
ln -s "$go_target/bin/gofmt" "$HOME/.local/bin/gofmt"
GOBIN="$HOME/.local/bin" go install golang.org/x/tools/gopls@v0.24.0
pyright --version
gopls version
nvim --version | head -n 3
starship --version
printf '\nDependencies ready. Run exec zsh, then nvim --headless "+Lazy! restore" +qa.\n'
printf 'WezTerm launches zsh explicitly; changing your default login shell is unnecessary.\n'
