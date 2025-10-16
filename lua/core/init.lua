require("core.autocmds")
require("core.cmds")
require("core.statusline")

require("core.options")
require("core.keymaps")
require("core.lazy")

if vim.g.neovide then
  require("core.neovide")
end

if vim.fn.has('nvim-0.12') == 1 then
  -- Enable the new experimental command-line features.
  require('vim._extui').enable {}
end
