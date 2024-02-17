return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-emoji" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-path" },
    { "onsails/lspkind.nvim" },
    { "saadparwaiz1/cmp_luasnip" },
    { 'f3fora/cmp-spell' },
    { 'hrsh7th/cmp-cmdline' },
    { 'ray-x/cmp-treesitter' },
    { "hrsh7th/cmp-nvim-lua" },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end
    },
  },
  config = function()
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local lspkind = require('lspkind')
    lspkind.init()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- cmp.confirm({ select = true })
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
            -- elseif luasnip.jumpable(-1) then
            --   luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      completion = {
        -- completeopt = "menu,menuone,preview,noinsert,noselect",
        completeopt = "menu,menuone,noinsert",
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip",                keyword_length = 3, max_item_count = 3 },
        { name = "buffer",                 keyword_length = 5, max_item_count = 3 },
        { name = 'spell' },
        { name = 'treesitter',             keyword_length = 5, max_item_count = 3 },
        { name = "nvim_lua",               group_index = 1 },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol',       -- show only symbol annotations
          maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          menu = {
            luasnip = "[snip]",
            nvim_lsp = "[LSP]",
            buffer = "[buf]",
            path = "[path]",
            spell = "[spell]",
            tags = "[tag]",
            treesitter = "[TS]",
            emoji = "[emoji]",
          },

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(_, vim_item)
            return vim_item
          end
        })
      },
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
