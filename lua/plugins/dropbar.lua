vim.pack.add({
  { src = "https://github.com/Bekaboo/dropbar.nvim" },
}, { confirm = false })
-- Winbar component using lsp
--
vim.defer_fn(function()
  require("dropbar").setup({
    menu = {
      win_configs = {
        border = "rounded",
      },
    },
    bar = {
      sources = function(buf, _)
        local sources = require("dropbar.sources")
        local utils = require("dropbar.utils")
        local filename = {
          get_symbols = function(buff, win, cursor)
            local path = sources.path.get_symbols(buff, win, cursor)

            return { path[#path] }
          end,
        }
        if vim.bo[buf].ft == "markdown" then
          return {
            filename,
            utils.source.fallback({
              sources.treesitter,
              sources.markdown,
              sources.lsp,
            }),
          }
        end
        return {
          filename,
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
      end,
    },

  })

  vim.keymap.set("n", "<Leader>;", function() require("dropbar.api").pick() end,
    { desc = "Dropbar: Pick symbols in winbar" })
  vim.keymap.set("n", "[;", function() require("dropbar.api").goto_context_start() end,
    { desc = "Dropbar: Go to start of current context" })
  vim.keymap.set("n", "];", function() require("dropbar.api").select_next_context() end,
    { desc = "Dropbar: Select next context" })
end, 200)
