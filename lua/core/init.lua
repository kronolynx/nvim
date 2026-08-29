require("core.autocmds")
require("core.cmds")

require("core.options")
require("core.keymaps")
require("plugins.init")

if vim.g.neovide then
  require("core.neovide")
end

-- if vim.fn.has('nvim-0.12') == 1 then
--   -- Enable the new experimental command-line features.
--   require('vim._extui').enable({
--     enable = true, -- Whether to enable or disable the UI.
--     msg = {     -- Options related to the message module.
--       ---@type 'cmd'|'msg' Where to place regular messages, either in the
--       ---cmdline or in a separate ephemeral message window.
--       target = 'cmd',
--       timeout = 4000, -- Time a message is visible in the message window.
--     },
--   })
-- end
