local opt = vim.opt

local g = vim.g

local global_opt = vim.opt_global

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '

global_opt.scrolloff = 5

opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
opt.history = 1000                         -- store the last 1000 commands entered
opt.magic = true       -- set magic on, for regular expressions

-- searching
opt.ignorecase = true  -- case insensitive searching
opt.smartcase = true   -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true    -- highlight search results
opt.incsearch = true   -- set incremental search, like modern browsers

opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true       -- set magic on, for regular expressions

opt.autowrite = true -- save on buffer change
-- opt.autowriteall = true -- save on buffer change -- TODO compare with autowrite

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
opt.cmdheight = 1       -- Height of the command bar
opt.cursorline = true   -- Highlight current line
opt.signcolumn = "yes"

-- toggle invisible characters
opt.list = true
opt.listchars = {
  tab = "→ ",
  eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮"
}
