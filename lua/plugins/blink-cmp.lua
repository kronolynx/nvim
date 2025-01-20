return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  -- enabled = false,
  version = "v0.*",
  opts = {
    signature = {
      enabled = true,
      window = {
        border = "single"
      }
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        auto_show = true,
        border = "single",
        draw = {
          treesitter = { "lsp" }, -- Use treesitter to highlight the label text
        },
      },
      -- Insert completion item on selection, don't select by default
      list = { selection = { preselect = false, auto_insert = true } },
      -- Show documentation when selecting a completion item
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = "single"
        }
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = {
      -- sorts = { 'label', 'kind', 'score' }
      sorts = { 'score', 'sort_text' },
    },

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      -- preset = 'enter',
      ['<C-space>'] = { "show", "show_documentation", "hide_documentation" },
      ['<C-e'] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up" },
      ["<C-f>"] = { "scroll_documentation_down" },

      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
    },
  },
  -- config = function (_, opts)
  --   local icons = require('util.icons')
  --   opts.appearance = opts.appearance or {}
  --   opts.appearance.kind_icons = icons.symbol_kinds
  -- end
}
