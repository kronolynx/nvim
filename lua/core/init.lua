require("core.autocmds")
require("core.cmds")

require("core.options")
require("core.keymaps")
require("core.lazy")

if vim.g.neovide then
  require("core.neovide")
end
