-- Winbar component using lsp
return {
  {
    "Bekaboo/dropbar.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    -- enabled = false,
    event = "VeryLazy",
    keys = {
      { "<Leader>;", function() require("dropbar.api").pick() end,                desc = "Dropbar: Pick symbols in winbar" },
      { "[;",        function() require("dropbar.api").goto_context_start() end,  desc = "Dropbar: Go to start of current context" },
      { "];",        function() require("dropbar.api").select_next_context() end, desc = "Dropbar: Select next context" },
    },
    config = function()
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
    end,
  },
}
