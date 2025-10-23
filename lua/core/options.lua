local arrows = require('util.icons').arrows
-- General options
local opt = vim.opt
local g = vim.g

-- Leader keys (must be set before plugins)
g.mapleader = ' '
g.maplocalleader = ' '

-- Disable netrw (recommended for plugin managers like nvim-tree)
g.loaded_netrwPlugin = 1

-- UI
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.cursorcolumn = true
opt.signcolumn = "yes"
opt.showcmd = true
opt.cmdheight = 0 -- Modern floating cmdline (Neovim 0.9+)
opt.termguicolors = true
opt.scrolloff = 7

-- Clipboard (use system clipboard on Mac)
opt.clipboard = "unnamedplus"

-- History & undo
opt.history = 1000
opt.undofile = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- Indentation
local indent = 2
opt.expandtab = true
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent

-- Spelling
opt.spelllang = 'en_us'
opt.spell = false

-- Invisible characters
opt.list = true
opt.listchars = {
  tab = " →",
  trail = "¬",
  extends = "❯",
  precedes = "❮"
}

-- Folds
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel = 99
opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldclose = arrows.right,
  foldopen = arrows.down,
  foldsep = ' ',
  foldinner = ' ',
  msgsep = '─',
}

-- Completion
opt.wildignore:append { '.DS_Store' }
opt.completeopt = 'menuone,noselect,noinsert'
opt.pumheight = 15

-- Short messages
opt.showmode = false
opt.shortmess:append {
  A = true, -- ATTENTION swap
  F = true, -- don't give file info when editing
  I = true, -- intro message
}

-- Quickfix
g.qf_disable_statusline = 1

-- Auto-reload files changed outside of Neovim
opt.autoread = true

-- Cursor update time (for plugins like gitgutter, lsp, etc.)
opt.updatetime = 300

-- Grep (use ripgrep if available)
opt.grepprg = 'rg --vimgrep'
opt.grepformat = '%f:%l:%c:%m'

-- GUI cursor
opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
}

-- Filetype for .http files
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- Add cfilter plugin for quickfix filtering
vim.cmd.packadd('cfilter')

-- VSCode-specific settings
if g.vscode then
  local vscode = require("vscode")
  vim.notify = vscode.notify
  g.clipboard = g.vscode_clipboard
  vim.notify("VScode-nvim settings loaded", vim.log.levels.INFO, { title = "LazyVim" })
end
