# yunamaki3/dotfiles

Clean, cross-platform terminal environment for macOS, Windows/WSL, WezTerm and LazyVim.

## Design

- Dark navy base with restrained cyan accents
- Light transparency and platform-native blur
- `FiraMono Nerd Font Mono` for code and icons
- `Noto Sans Mono CJK JP` for Japanese text
- One WezTerm configuration with OS-specific Leader keys
- LazyVim for C, Markdown and web development

## Leader keys

| Environment | Leader |
| --- | --- |
| WezTerm on macOS | `Option+Q` |
| WezTerm on Windows | `Ctrl+Q` |
| Neovim/LazyVim | `Space` |

After pressing the WezTerm Leader, use:

| Key | Action |
| --- | --- |
| `v` / `s` | Split left-right / top-bottom |
| `h j k l` | Move between panes |
| `H J K L` | Resize panes |
| `c` | New tab |
| `n` / `p` | Next / previous tab |
| `x` | Close current pane |
| `z` | Zoom current pane |
| `[` | Vim-style copy mode; select with `v`, copy with `y` |
| `r` | Reload WezTerm configuration |

## macOS setup

Install Apple's Command Line Tools first:

```sh
xcode-select --install
```

Then install the packages and apply the links:

```sh
brew install neovim starship ripgrep fd fzf llvm node
brew install --cask font-fira-mono-nerd-font font-noto-sans-cjk
./scripts/setup-macos.sh
```

Restart WezTerm and run `nvim`. LazyVim installs its plugins on first launch.

## Windows and WSL setup

Clone this repository in Windows, for example at `%USERPROFILE%\dotfiles`. From PowerShell:

```powershell
winget install wez.wezterm
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
```

Install `FiraMono Nerd Font Mono` and `Noto Sans Mono CJK JP` in Windows. Then open WSL, enter the same repository through `/mnt/c/Users/<name>/dotfiles`, and run:

```sh
./scripts/setup-wsl.sh
```

Install Neovim 0.11 or newer plus `git`, `clang`, `ripgrep`, `fd`, `node` and `starship` in the WSL distribution. Avoid distribution packages that provide an older Neovim.

## C workflow

Open a C file with `nvim hello.c`. LazyVim provides clangd completion and diagnostics. Press `Space c r` to save, compile with strict warnings, and run the current file. Formatting is available through LazyVim's normal formatting command.

## Updating

- `:Lazy` manages Neovim plugins.
- `:Mason` shows language tools.
- Machine-specific secrets and credentials do not belong in this repository.

