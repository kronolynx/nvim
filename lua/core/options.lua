local arrows = require('util.icons').arrows
local opt = vim.opt
local g = vim.g

-- ============================================================================
-- Leader Keys (must be set before plugins)
-- ============================================================================
g.mapleader = ' '
g.maplocalleader = ' '

-- ============================================================================
-- Disable Built-in Plugins (faster startup)
-- ============================================================================
g.loaded_2html_plugin = 1
g.loaded_gzip = 1
g.loaded_zipPlugin = 1
g.loaded_tarPlugin = 1
g.loaded_tar = 1
g.loaded_zip = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_logipat = 1
g.loaded_rrhelper = 1
g.loaded_spellfile_plugin = 1
g.loaded_fzf = 1

-- ============================================================================
-- UI Settings
-- ============================================================================
opt.number = true                  -- Show line numbers
opt.relativenumber = true          -- Show relative line numbers
opt.cursorline = true              -- Highlight current line
opt.cursorcolumn = false           -- Highlight current column
opt.signcolumn = "yes"             -- Always show sign column
opt.showcmd = true                 -- Show command in status line
opt.cmdheight = 0                  -- Use floating cmdline (Neovim 0.9+)
opt.showmode = false               -- Don't show mode (statusline shows it)
opt.termguicolors = true           -- Enable 24-bit RGB colors
opt.scrolloff = 7                  -- Keep 7 lines visible above/below cursor
opt.smoothscroll = true            -- Smooth scrolling for wrapped lines (nightly)
opt.linebreak = true               -- Wrap long lines at word boundaries

-- Invisible characters
opt.list = true
opt.listchars = {
  tab = " →",
  trail = "¬",
  extends = "❯",
  precedes = "❮"
}

-- Fill characters for various UI elements
opt.fillchars = {
  eob = ' ',                       -- Empty lines at end of buffer
  fold = ' ',
  foldclose = arrows.right,
  foldopen = arrows.down,
  foldsep = ' ',
  foldinner = ' ',
  msgsep = '─',
}

-- ============================================================================
-- Editor Behavior
-- ============================================================================
opt.mouse = "a"                    -- Enable mouse in all modes
opt.mousemodel = "extend"          -- Right click extends selection
opt.clipboard = "unnamedplus"      -- Use system clipboard
opt.virtualedit = "block"          -- Allow cursor beyond line end in visual block mode

-- Formatting
opt.formatoptions = "jqlnt"        -- Auto-formatting options (j=smart comments, q=format with gq, l=long lines, n=numbered lists, t=autowrap text)

-- ============================================================================
-- Search Settings
-- ============================================================================
opt.ignorecase = true              -- Ignore case when searching
opt.smartcase = true               -- Override ignorecase if search has uppercase
opt.hlsearch = true                -- Highlight search results
opt.incsearch = true               -- Show search matches as you type
opt.inccommand = "split"           -- Show live preview of substitute commands

-- ============================================================================
-- Split Behavior
-- ============================================================================
opt.splitbelow = true              -- Open horizontal splits below
opt.splitright = true              -- Open vertical splits to the right
opt.splitkeep = "screen"           -- Keep text stable when splitting (nightly)

-- ============================================================================
-- Indentation
-- ============================================================================
local indent = 2
opt.expandtab = true               -- Convert tabs to spaces
opt.tabstop = indent               -- Number of spaces a tab counts for
opt.shiftwidth = indent            -- Number of spaces for auto-indent
opt.softtabstop = indent           -- Number of spaces for <Tab> in insert mode
opt.smartindent = true             -- Smart auto-indenting

-- ============================================================================
-- History & Undo
-- ============================================================================
opt.history = 10000                -- Command history size
opt.undofile = true                -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"  -- Centralize undo files
opt.undolevels = 10000             -- Maximum number of undo levels
opt.autoread = true                -- Auto-reload files changed outside Neovim

-- ============================================================================
-- Performance
-- ============================================================================
opt.updatetime = 300               -- Faster completion and CursorHold events (ms)
opt.timeoutlen = 300               -- Time to wait for mapped sequence (ms)

-- ============================================================================
-- Completion & Wildmenu
-- ============================================================================
opt.completeopt = 'menuone,noselect,noinsert'  -- Better completion experience
opt.pumheight = 15                 -- Max items in completion popup
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wildoptions = "pum"            -- Use popup menu for wildmenu
opt.wildignore:append { '.DS_Store' }  -- Ignore patterns

-- ============================================================================
-- Folding
-- ============================================================================
opt.foldmethod = "indent"          -- Fold based on indentation
opt.foldenable = false             -- Don't fold by default
opt.foldlevel = 99                 -- High fold level = most folds open

-- ============================================================================
-- Spelling
-- ============================================================================
opt.spell = false                  -- Disable spell check by default
opt.spelllang = 'en_us'            -- Spell check language

-- ============================================================================
-- Grep Integration
-- ============================================================================
opt.grepprg = 'rg --vimgrep'       -- Use ripgrep for :grep
opt.grepformat = '%f:%l:%c:%m'     -- Format for grep output

-- ============================================================================
-- Diff Settings
-- ============================================================================
opt.diffopt:append("linematch:60") -- Better diff algorithm (nightly)

-- ============================================================================
-- GUI Settings
-- ============================================================================
opt.guicursor = {
  "n-v-c:block",                   -- Block cursor in normal/visual/command
  "i-ci-ve:ver25",                 -- Thin cursor in insert
  "r-cr:hor20",                    -- Horizontal cursor in replace
  "o:hor50",                       -- Horizontal cursor in operator-pending
}

-- ============================================================================
-- Messages
-- ============================================================================
opt.shortmess:append {
  A = true,                        -- Don't show ATTENTION swap messages
  F = true,                        -- Don't give file info when editing
  I = true,                        -- Don't show intro message
}

-- ============================================================================
-- Quickfix
-- ============================================================================
g.qf_disable_statusline = 1        -- Don't override statusline in quickfix

-- ============================================================================
-- Session Options
-- ============================================================================
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- ============================================================================
-- Filetype Associations
-- ============================================================================
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- ============================================================================
-- Built-in Plugins
-- ============================================================================
vim.cmd.packadd('cfilter')         -- Load quickfix filtering plugin

-- ============================================================================
-- VSCode Integration
-- ============================================================================
if g.vscode then
  local vscode = require("vscode")
  vim.notify = vscode.notify
  g.clipboard = g.vscode_clipboard
  vim.notify("VScode-nvim settings loaded", vim.log.levels.INFO, { title = "Neovim" })
end
