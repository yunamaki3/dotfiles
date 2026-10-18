-- ============================================================
-- キー入力ロガー
-- 置き場所: ~/.config/nvim/lua/config/keylog.lua
-- init.lua に require("config.keylog") を追記して読み込む
--
-- 使い方:
--   :KeyLog      → 記録の開始/停止を切り替え
--   :KeyLogOpen  → ログファイルを開く
-- ============================================================

-- ログの保存先 (~/.local/share/nvim/keylog.txt)
local log_file = vim.fn.stdpath("data") .. "/keylog.txt"

-- vim.on_key の登録を後で解除するための「名前空間」(識別用のID)
local ns = vim.api.nvim_create_namespace("my_keylogger")

local logging = false  -- 今記録中かどうかのフラグ
local buffer = {}      -- 毎回ファイルに書くと遅いので、一旦ここに溜める

-- 溜めた分をファイルに書き出す関数
local function flush()
  if #buffer == 0 then return end
  local f = io.open(log_file, "a") -- "a" = 追記モードで開く
  if f then
    f:write(table.concat(buffer))
    f:close()
  end
  buffer = {}
end

local function start()
  -- セッションの区切りを書いておく(あとで見返しやすい)
  local f = io.open(log_file, "a")
  if f then
    f:write(("\n===== %s =====\n"):format(os.date("%Y-%m-%d %H:%M:%S")))
    f:close()
  end

  -- ここが本体: キーが押されるたびにこの関数が呼ばれる
  vim.on_key(function(key, typed)
    -- typed = ユーザーが実際に打ったキー / key = マップ展開後のキー
    -- 「自分が何を打ったか」を知りたいので typed を優先する
    local k = (typed ~= "" and typed) or key
    if k == "" then return end

    -- keytrans: 生の制御文字を "<Esc>" "<C-n>" のような読める表記に変換
    local readable = vim.fn.keytrans(k)

    -- 今のモードを取得 (n=ノーマル, i=挿入, v=ビジュアル, V=行ビジュアル,
    -- c=コマンドライン など。:h mode() に一覧があります)
    local mode = vim.fn.keytrans(vim.api.nvim_get_mode().mode)

    -- 例: [n] j   /   [i] <Esc>  のような1行を溜める
    table.insert(buffer, ("[%s] %s\n"):format(mode, readable))

    -- 50キーごとにまとめてファイルへ書き出す
    if #buffer >= 50 then flush() end
  end, ns)

  logging = true
  vim.notify("キーログ開始 → " .. log_file)
end

local function stop()
  vim.on_key(nil, ns) -- nil を渡すと記録関数が解除される
  flush()             -- 溜まっている分を書き切る
  logging = false
  vim.notify("キーログ停止")
end

-- :KeyLog でON/OFFをトグル
vim.api.nvim_create_user_command("KeyLog", function()
  if logging then stop() else start() end
end, { desc = "キー入力の記録を開始/停止" })

-- :KeyLogOpen でログファイルを開く
vim.api.nvim_create_user_command("KeyLogOpen", function()
  flush()
  vim.cmd.edit(log_file)
end, { desc = "キーログを開く" })

-- Neovim終了時に書き残しがないようにする
vim.api.nvim_create_autocmd("VimLeavePre", { callback = flush })
