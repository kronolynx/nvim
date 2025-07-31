local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- /Users/jortiz/.local/share/nvim/lazy/lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
--
-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--   augroup lazy_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | Lazy sync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Setup lazy.nvim
-- local plugins = {}
-- if not vim.g.vscode then
--   plugins = { import = "plugins.nvim" }
-- end
return lazy.setup({
  spec = {
    -- { import = "plugins.common" },
    { import = "plugins" },
    -- { import = "plugins.code" },
    -- plugins
  },
  defaults = {
    cond = not vim.g.vscode,
  },
  -- automatically check for plugin updates
  checker = { enabled = false },

  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
