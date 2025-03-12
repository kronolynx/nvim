local opt = vim.opt

local g = vim.g

local global_opt = vim.opt_global

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '
-- disable netrw
g.loaded_netrwPlugin = 1

global_opt.scrolloff = 7

vim.o.termguicolors = true

opt.clipboard = { "unnamedplus" } -- use the system clipboard
opt.history = 1000                -- store the last 1000 commands entered

opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  -- "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  -- "sm:block-blinkwait175-blinkoff150-blinkon175"
}

-- searching
opt.ignorecase = true    -- case insensitive searching
opt.smartcase = true     -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true      -- highlight search results
opt.incsearch = true     -- set incremental search, like modern browsers
opt.inccommand = "split" -- show live preview of substitution

opt.undofile = true      -- save undo history to file

-- opt.lazyredraw = true    -- don't redraw while executing macros
opt.magic = true -- set magic on, for regular expressions

opt.showmode = false

opt.conceallevel = 2 -- show conceals
-- disable wrap of long lines
opt.wrap = false

-- TODO fix scroll size to 1/3 or 1/4 of the window height
-- opt.scroll = vim.fn.winheight(0) / 3
-- opt.scroll = 10 -- math.floor(vim.fn.winheight(0) / 4)
-- vim.o.scroll = 10 -- math.floor(vim.fn.winheight(0) / 4)

-- indentation
local indent = 2
opt.expandtab = true -- Expand tabs to spaces
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true

opt.spelllang = 'en_us'
opt.spell = false -- TODO investigate why CamelCase words are reported as error,  fix spell error keybinding `z=`

-- interface
opt.showcmd = true      -- Show the (partial) command as it’s being typed
opt.number = true       -- show line numbers
opt.cmdheight = 0       -- Height of the command bar -- TODO fix problems with messages and flickering
opt.cursorline = true   -- Highlight current line
opt.cursorcolumn = true -- Highlight current column
opt.signcolumn = "yes"

-- toggle invisible characters
opt.list = true
opt.listchars = {
  tab = " →",
  -- eol = "¬",
  -- trail = "␣", --
  trail = "¬", --
  extends = "❯",
  precedes = "❮"
}

opt.fillchars = { fold = " " }
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel = 99
-- opt.foldtext = "...."
-- opt.foldmethod = "expr"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldtext = ""
-- opt.foldnestmax = 3
-- opt.foldlevel = 99
-- opt.foldlevelstart = 99


-- Completion.
opt.wildignore:append { '.DS_Store' }
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.pumheight = 15

-- completion
-- opt.wildmode = "list:longest,full"
-- opt.wildmenu = true

-- opt.shortmess:append("c") -- "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
-- opt.shortmess:append("s") -- hit BOTTOM
-- opt.shortmess:append("A") -- ATTENTION swap
-- opt.shortmess:append("I") -- intro message when starting

-- suppress messages
-- :h shortmess
opt.shortmess:append {
  A = true, -- ATTENTION swap
  F = true, -- don't give the file info when editing a file, like `:silent was used`.
  I = true, -- intro message when starting
  W = true, -- don't give "written" or "[w]" when writing a file
  q = true, -- don't show recording info
  c = true, -- "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
  n = true, -- no write since last change
  o = true, -- overwriting a file
  s = true, -- hit BOTTOM
}

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true

--  delay (in milliseconds) after which the cursor is considered idle and triggers certain events, such as the CursorHold event
vim.api.nvim_set_option('updatetime', 300)

-- Use ripgrep for grepping.
vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'

-- local last_showcmd_linger = 1000
-- local ns = vim.api.nvim_create_namespace('showcmd_msg')
-- local function set_showmess(mess)
--   if mess ~= '' then
--     vim.notify(mess)
--   end
-- end
--
-- vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
--   if event == 'msg_showcmd' then
--     local content = ...
--     local event_group, event_type = event:match("([a-z]+)_(.*)")
--     local on = "on_" .. event_type
--     vim.notify(event_group)
--     vim.notify(on)
--     if #content > 0 then
--       local it = vim.iter(content)
--       it:map(function(tup) return tup[2] end)
--       set_showmess(it:join(''))
--     end
--   end
-- end)
--
-----@enum MsgEvent
-- M.events = {
--   show = "msg_show",
--   clear = "msg_clear",
--   showmode = "msg_showmode",
--   showcmd = "msg_showcmd",
--   ruler = "msg_ruler",
--   history_show = "msg_history_show",
--   history_clear = "msg_history_clear",
-- }
--
-- local M = {}
-- ---@enum MsgKind
-- M.kinds = {
--   -- echo
--   empty = "", -- (empty) Unknown (consider a feature-request: |bugs|)
--   echo = "echo", --  |:echo| message
--   echomsg = "echomsg", -- |:echomsg| message
--   -- input related
--   confirm = "confirm", -- |confirm()| or |:confirm| dialog
--   confirm_sub = "confirm_sub", -- |:substitute| confirm dialog |:s_c|
--   return_prompt = "return_prompt", -- |press-enter| prompt after a multiple messages
--   -- error/warnings
--   emsg = "emsg", --  Error (|errors|, internal error, |:throw|, …)
--   echoerr = "echoerr", -- |:echoerr| message
--   lua_error = "lua_error", -- Error in |:lua| code
--   rpc_error = "rpc_error", -- Error response from |rpcrequest()|
--   wmsg = "wmsg", --  Warning ("search hit BOTTOM", |W10|, …)
--   -- hints
--   quickfix = "quickfix", -- Quickfix navigation message
--   search_count = "search_count", -- Search count message ("S" flag of 'shortmess')
-- }
--
-- local ns = vim.api.nvim_create_namespace('showcmd_msg')
-- local function set_showmess(mess)
--   if mess ~= '' then
--     vim.notify(mess)
--   end
-- end
--
-- function M.is_error(kind)
--   return vim.tbl_contains({ M.kinds.echoerr, M.kinds.lua_error, M.kinds.rpc_error, M.kinds.emsg }, kind)
-- end
--
-- function M.is_warning(kind)
--   return kind == M.kinds.wmsg
-- end
--
-- vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
--     local event_group, event_type = event:match("([a-z]+)_(.*)")
--     local on = "on_" .. event_type
--
--   if event == M.events.showcmd then
--     local content = ...
--     local event_group, event_type = event:match("([a-z]+)_(.*)")
--     local on = "on_" .. event_type
--     vim.notify(event_group)
--     vim.notify(on)
--     if #content > 0 then
--       local it = vim.iter(content)
--       it:map(function(tup) return tup[2] end)
--       set_showmess(it:join(''))
--     end
--   end
-- end)
-- vim.filetype.add({
--   extension = {
--     ['http'] = 'http',
--   },
-- })
