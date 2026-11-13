# 今のWindows PCと同じ環境を別PCへ導入する

2026-11-13に稼働中の設定から収録した `profiles/windows-wsl/` 用の手順です。
WindowsのWezTermからWSL Ubuntuのzshを開き、その中でNeovimを使います。
既存の `.config/` は別のLazyVimプロファイルなので混ぜないでください。

## 1. 新しいPCのWindows側

管理者PowerShellでWSLを導入します（導入済みなら不要）。再起動を求められたら再起動し、Ubuntuを一度起動してLinuxユーザー名・パスワードを作成してください。

```powershell
wsl --install -d Ubuntu
```

通常のPowerShellでGitとWezTermを導入します。

```powershell
winget install --id Git.Git -e
winget install --id wez.wezterm -e
```

PowerShellを開き直し、リポジトリを取得して設定とフォントを適用します。

```powershell
git clone https://github.com/yunamaki3/dotfiles.git "$env:USERPROFILE\dotfiles"
cd "$env:USERPROFILE\dotfiles"
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup-current-windows.ps1 -InstallFonts
```

- `-WhatIf` を付けると設定適用先だけ確認できます。
- `wsl -l -q` に表示される名前が `Ubuntu-24.04` などの場合は `-Distro Ubuntu-24.04` も付けてください。
- `-InstallFonts` は公式配布元からFiraMono Nerd Font・HackGen NFを取得します。Windows全体へのフォント登録は不要で、WezTerm専用フォルダーから読み込みます。
- オフラインなら事前に同フォントをWindowsへインストールし、`-InstallFonts` を省略できます。
- 現在の `.config\wezterm` と、優先読み込みされる `.wezterm.lua` は `.dotfiles-backup\日時-ID\` に退避します。シンボリックリンク／ジャンクションも対象です。
- `WEZTERM_CONFIG_FILE` / `WEZTERM_CONFIG_DIR` / `XDG_CONFIG_HOME` を独自設定しているPCは、その参照先も確認してください。

## 2. Ubuntu側

Ubuntuを開いて以下を実行します。Windowsとは別にLinuxホームにもcloneするため、Windowsユーザー名やドライブの位置をハードコードしません。

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/yunamaki3/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/install-current-wsl-deps.sh
bash scripts/setup-current-wsl.sh
exec zsh
```

続けてプラグインを保存済みのバージョンへ復元します。

```bash
nvim --headless "+Lazy! restore" +qa
nvim
```

初回のTreesitterパーサー構築には時間がかかります。Neovim内で `:TSUpdateSync` を実行し、必要なら再起動してください。`:checkhealth` で状態を確認できます。

Ubuntu 24.04を基準にしています。依存スクリプトはaptのツール、Neovim 0.12.3、Starship 1.26.0、TypeScript 5.9.2、typescript-language-server 4.4.1、Pyright 1.1.414、Go 1.27.3、gopls 0.24.0を導入します。NeovimとStarshipは公式リリースからLinuxホームへ配置し、npmは専用ディレクトリを使います。x86_64 / ARM64の配布名に対応していますが、実機検証はx86_64です。

WSLの既定ログインシェルは変更せず、WezTermから `zsh -l` を起動します。通常のUbuntuウィンドウでもzshにしたければ `chsh -s /usr/bin/zsh` を実行し、Ubuntuを開き直してください。

## 再現される内容

| 対象 | 内容 |
| --- | --- |
| WezTerm | 14pt、透明度0.85、濃紺背景、Solarized Dark Higher Contrast、タブの装飾、IME |
| フォント | FiraMono Nerd Font、HackGen Console NFのフォールバック |
| zsh | 履歴共有・重複除去、Tab補完、zsh-autosuggestions、ディレクトリ名だけでcd |
| Starship | 水色のディレクトリ表示、Git表示、右側に実行時間・ユーザー名・時計 |
| Neovim | Catppuccin mocha透明背景、Neo-tree、Telescope、Treesitter、LSP、nvim-cmp、vsnip、画面装飾、独自キーマップ |
| LSP | Pythonはpyright、C/C++はclangd、JavaScript/TypeScriptはts_ls、Goはgopls |
| バージョン固定 | `lazy-lock.json` に現在のプラグインコミットを保存、lazy.nvim本体も初回に固定コミットへcheckout |
| Bash | 現在の `.bashrc` / `.profile` も収録。ユーザー名の絶対パスを `$HOME` に変更 |

履歴の**予測機能**は再現しますが、履歴データは移行しません。別PCではコマンドの使用とともに候補が蓄積されます。日本語入力はWindowsのIME設定にも依存します。

元PCの `~/.vsnip` は空だったため、導入先に空ディレクトリだけ用意します。既存のスニペットは消しません。`ac-library` やProgateなど、Bash設定が参照する開発環境・ソースコードは必要に応じて別途導入してください。

## 主なキー操作（このプロファイル）

WezTermのLeaderは **Ctrl + ;**。押して離してから2秒以内に次のキーを押します。

| キー | 操作 |
| --- | --- |
| Ctrl+Shift+T / W | タブ作成 / 閉じる |
| Ctrl+Tab / Ctrl+Shift+Tab | 次 / 前のタブ |
| Alt+1〜9 | タブ選択 |
| Leader → d / r | 上下 / 左右へ分割 |
| Leader → h / j / k / l | ペイン移動 |
| Leader → s → h/j/k/l | ペインサイズ変更（Enterで終了） |
| Leader → z / x | ペイン拡大切り替え / 閉じる |
| Leader → [ | Vim風コピーモード |
| Leader → w / Shift+W | ワークスペース一覧 / 作成 |
| Ctrl+Shift+C / V | コピー / 貼り付け |
| Ctrl+Shift+R | WezTerm設定を再読み込み |
| Alt+Enter | 全画面切り替え |
| Neovim: jj | 挿入モードを抜ける |
| Neovim: Ctrl+N | Neo-tree開閉 |
| Neovim: Space f f / Space f g | ファイル / 全文検索 |
| Neovim: ss / sv、sh / sj / sk / sl | 分割、ウィンドウ移動 |
| Neovim: Tab / Shift+Tab | 補完候補・スニペット操作 |

Neovimの `:KeyLog` / `:KeyLogOpen` も収録しています。記録は初期状態でOFFです。手動で開始した場合のログはNeovimのデータディレクトリだけに保存され、Gitへ含めません。

## 更新・バックアップ・復元

### Python / C++ の補完と開発

2026-11-13に元PCと再照合し、既存の見た目・キー操作を維持してPythonのLSPを追加しました。補完は `nvim-cmp`、スニペット展開は `vim-vsnip` です。コード入力時に候補が表示され、`Ctrl+Space` で手動表示、`Tab` / `Shift+Tab` で移動、`Enter` で確定します。日本語の変換候補はWindows IMEが担当します。

- Python: `pyright` が補完・型診断・定義ジャンプを提供します。プロジェクトごとに `python3 -m venv .venv`、`source .venv/bin/activate`、必要なライブラリの `pip install` を行ってから `nvim` を開きます。依存ライブラリは各プロジェクトのrequirements.txt等から復元してください。
- C/C++: `clangd` が補完・診断を担当し、コンパイル用の `g++` と `cmake` も依存スクリプトで入ります。CMakeプロジェクトでは `cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` を実行します。独自のincludeパスや標準の指定はプロジェクト側の `compile_commands.json` または `.clangd` に記載してください。AtCoder Library本体は含みません。
- 共通: `gd` で定義へ、`K` で説明、`Space r n` で名前変更、`Space c a` でコードアクション。候補が出ない場合は `:checkhealth vim.lsp` で `pyright` / `clangd` の接続を確認します。
- Go: 元PCで追加されていた `gopls` 設定も収録しました。保存時の整形と `F5` の実行を引き継いでいます。

WezTermとNeovim本体だけではLSP、コンパイラー、フォント等は揃いません。上記のWindows/Ubuntu両側の導入が必要です。このプロファイルは **Windows + WSL Ubuntu** 向けです。macOS向けの従来設定は別プロファイルで、同じキー操作の再現対象には含まれません。

実行済み環境を更新する場合も、新しいPython/Go依存を入れるため `bash scripts/install-current-wsl-deps.sh` を一度実行し、設定を再適用してください。

参考: [Pyright公式の導入手順](https://github.com/microsoft/pyright/blob/main/docs/installation.md)、[Neovim LSP設定](https://github.com/neovim/nvim-lspconfig)。

コピー方式なので、WindowsとUbuntuの両方のcloneで `git pull --ff-only` 後に対応するsetupスクリプトを再実行してください。フォントや依存ツールが変わっていなければ、それらの再インストールは不要です。

Ubuntuのsetupはnvimディレクトリ、Starship、`.zshrc`、`.bashrc`、`.profile` を `$HOME/.dotfiles-backup/日時-PID/` に退避します。`--dry-run` で確認できます。PC固有の追加設定は `~/.zshrc.local` に置けば維持されます。XDG_CONFIG_HOMEがある場合はそれに従います。

復元するときはWezTerm／Neovimを閉じ、新しく配置された設定を別名に変更してから、出力されたバックアップの各ファイルを元の位置に戻してください。Ubuntuの `zshrc` / `bashrc` / `profile` は元の `.zshrc` / `.bashrc` / `.profile` へ名前を戻します。

このリポジトリには認証情報、SSH鍵、シェル履歴、キーログ、キャッシュ、プラグイン本体、フォント本体を含めません。移行元で動いている設定は変更していません。

## 参考

- [WezTermのWSLドメイン](https://wezterm.org/config/lua/config/wsl_domains.html)
- [lazy.nvimのlockfileとrestore](https://lazy.folke.io/usage/lockfile)
- [FiraMono Nerd Fontの配布](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.5.1)
- [HackGen NFの配布](https://github.com/yuru7/HackGen/releases/tag/v2.10.0)
