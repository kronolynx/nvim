return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  -- enabled = false,
  version = '1.*',
  dependencies = "milanglacier/minuet-ai.nvim",
  opts = {
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
      -- Manually invoke minuet completion.
      ['<A-y>'] = require('minuet').make_blink_map(),
    },
    signature = {
      enabled = true,
      window = {
        border = "single"
      }
    },
    completion = {
      -- Recommended to avoid unnecessary request for AI completions
      trigger = { prefetch_on_insert = false },
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = false,
        },
      },
      menu = {
        auto_show = true,
        border = "single",
        draw = {
          treesitter = { "lsp" }, -- Use treesitter to highlight the label text
        },
      },
      list = {
        -- Insert completion item on selection, don't select by default
        selection = { preselect = false, auto_insert = false },
        max_items = 10,
      },
      -- Show documentation when selecting a completion item
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = "single"
        }
      },
    },
    snippets = { preset = 'luasnip' },
    sources = {
      -- Disable some sources in comments and strings.
      default = function()
        local sources = { 'lsp', 'buffer' }
        local ok, node = pcall(vim.treesitter.get_node)

        if ok and node then
          if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            table.insert(sources, 'path')
          end
          if node:type() ~= 'string' then
            table.insert(sources, 'snippets')
          end
        end

        return sources
      end,
      per_filetype = {
        codecompanion = { 'codecompanion', 'buffer' },
      },
      -- For manual completion only, remove 'minuet' from default
      providers = {
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          score_offset = 8, -- Gives minuet higher priority among suggestions
        },
      },
    },
    appearance = {
      kind_icons = require('util.icons').symbol_kinds,
    },
    fuzzy = {
      -- sorts = { 'label', 'kind', 'score' }
      sorts = { 'score', 'sort_text' },
    },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    -- On Neovim 0.11+ with vim.lsp.config, you may skip this step. See nvim-lspconfig docs
    -- Extend neovim's client capabilities with the completion ones.
    -- vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
  end,
}
