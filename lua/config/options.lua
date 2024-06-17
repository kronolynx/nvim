local opt = vim.opt

local g = vim.g

local global_opt = vim.opt_global

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '
 -- disable netrw
g.loaded_netrwPlugin = 1

global_opt.scrolloff = 7

opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
opt.history = 1000                         -- store the last 1000 commands entered

-- searching
opt.ignorecase = true  -- case insensitive searching
opt.smartcase = true   -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true    -- highlight search results
opt.incsearch = true   -- set incremental search, like modern browsers

opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true       -- set magic on, for regular expressions

opt.conceallevel = 2   -- show conceals
-- disable wrap of long lines
opt.wrap = false

-- indentation
local indent = 2
opt.expandtab = true   -- Expand tabs to spaces
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true

-- interface
opt.showcmd = true      -- Show the (partial) command as it’s being typed
opt.number = true    -- show line numbers
opt.cmdheight = 0       -- Height of the command bar
opt.cursorline = true   -- Highlight current line
opt.signcolumn = "yes"

-- toggle invisible characters
opt.list = true
opt.listchars = {
  tab = "→ ",
  -- eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮"
}

-- completion
-- opt.wildmode = "list:longest,full"
-- opt.wildmenu = true

-- suppress messages
-- :h shortmess 
opt.shortmess:append("c") -- "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
opt.shortmess:append("s") -- hit BOTTOM
opt.shortmess:append("A") -- ATTENTION swap
opt.shortmess:append("I") -- intro message when starting

--  delay (in milliseconds) after which the cursor is considered idle and triggers certain events, such as the CursorHold event
vim.api.nvim_set_option('updatetime', 300)

