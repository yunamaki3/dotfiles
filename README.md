# yunamaki3/dotfiles

macOS・Windows/WSLで、WezTerm・Starship・LazyVimを同じ見た目と操作感で使うための設定ファイルです。

詳しい導入手順とキーバインドは、白背景の単一HTMLガイド [`SETUP.html`](./SETUP.html) にまとめています。

## 主な内容

- WezTerm：濃紺ベース、半透明、OS別Leaderキー、ペイン・タブ操作
- Starship：現在のディレクトリ、Gitブランチ、変更状態、言語バージョンを表示
- LazyVim：C、Markdown、JSON、TypeScript、Tailwind CSS向け設定
- macOS・Windows・WSL用セットアップスクリプト

## macOSへの導入

Apple Command Line Toolsと必要なパッケージを入れます。

```sh
xcode-select --install
brew install neovim starship ripgrep fd fzf llvm node
brew install --cask font-fira-mono-nerd-font font-noto-sans-cjk
```

リポジトリを取得し、設定へのシンボリックリンクを作ります。

```sh
git clone https://github.com/yunamaki3/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/setup-macos.sh
```

WezTermを再起動して `nvim` を実行してください。初回のみプラグインやツールのインストールに時間がかかります。

## Windows・WSLへの導入

Windows側でWezTermを導入し、PowerShellで設定を適用します。

```powershell
winget install wez.wezterm
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
```

Windowsに `FiraMono Nerd Font Mono` と `Noto Sans Mono CJK JP` をインストールしてください。その後WSLでリポジトリに移動し、次を実行します。

```sh
./scripts/setup-wsl.sh
```

WSL側にはNeovim 0.11以降、Git、Clang、ripgrep、fd、Node.js、Starshipが必要です。

## Leaderキーの使い方

WezTermでは、Leaderキーを押して離した後、1.5秒以内に次のキーを押します。同時押しではありません。

| 環境 | Leaderキー |
| --- | --- |
| macOS | `Option + Q` |
| Windows | `Ctrl + Q` |
| LazyVim | `Space` |

## WezTermキーバインド

以下はすべて「Leaderを押してから、次のキーを押す」操作です。

| キー | 操作 |
| --- | --- |
| `f` | 全画面表示のオン・オフ |
| `v` | 左右にペイン分割 |
| `s` | 上下にペイン分割 |
| `h` / `j` / `k` / `l` | 左 / 下 / 上 / 右のペインへ移動 |
| `H` / `J` / `K` / `L` | ペインを左 / 下 / 上 / 右へ拡縮 |
| `c` | 新しいタブを作成 |
| `n` / `p` | 次 / 前のタブへ移動 |
| `x` | 現在のペインを閉じる |
| `z` | 現在のペインだけを一時的に拡大・復元 |
| `[` | Vim風コピーモードを開始 |
| `r` | WezTerm設定を再読み込み |
| `q` | コマンドパレットを表示 |

タイトルバーを非表示にしていても、`Leader → f` で全画面表示を切り替えられます。WezTerm標準の `Alt + Enter` も使用できます。

### コピーモード

`Leader → [` で開始します。

| キー | 操作 |
| --- | --- |
| `h` / `j` / `k` / `l` | カーソル移動 |
| `w` / `b` | 次 / 前の単語へ移動 |
| `0` / `$` | 行頭 / 行末へ移動 |
| `g` / `G` | 履歴の先頭 / 末尾へ移動 |
| `v` / `V` | 文字単位 / 行単位の選択開始 |
| `y` | 選択範囲をコピーして終了 |
| `Esc` / `q` | コピーせず終了 |

## 更新方法

実際に使用しているdotfilesディレクトリで実行します。設定はシンボリックリンクされているため、通常は再セットアップ不要です。

```sh
cd ~/dotfiles
git pull origin main
```

反映されない場合は、`Leader → r` でWezTerm設定を再読み込みし、シェル表示は `exec zsh` で読み直します。

## Neovim・LazyVim

- `:Lazy`：プラグインの確認・更新
- `:Mason`：LSP、フォーマッター、外部ツールの確認
- `:checkhealth`：問題の診断
- `Space c r`：Cファイルを保存、コンパイル、実行

初回起動時はプラグインや `tree-sitter-cli` の取得が並行して行われます。一時的なインストール中エラーが出た場合は、完了を待ってNeovimを再起動してください。

## 注意

APIキー、パスワード、個人用トークンなどの秘密情報は、このリポジトリへ追加しないでください。
