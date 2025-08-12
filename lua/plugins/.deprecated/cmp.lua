return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  enabled = false,
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
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
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local icons = require('util.icons')
    local symbol_kinds = icons.symbol_kinds

    local select_next = cmp.mapping(function(fallback)
      -- local copilot = require 'copilot.suggestion'

      -- if copilot.is_visible() then
      --   copilot.accept()
      -- elseif cmp.visible() and has_words_before() then
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })

        -- elseif cmp.visible() then
        --   -- cmp.confirm({ select = true })
        --   cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
        -- elseif luasnip.expand_or_jumpable() then
        --   luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' })

    local select_prev = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump(-1)
        -- elseif luasnip.jumpable(-1) then
        --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-n>'] = select_next,
        ['<C-p>'] = select_prev,
        ['<Down>'] = select_next,
        ['<Up>'] = select_prev,
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Explicitly request completions.
        ['<C-Space>'] = cmp.mapping.complete {},
        ["<C-e>"] = cmp.mapping.abort(),
        ['<C-/>'] = cmp.mapping.close(),
        ['<Right>'] = cmp.mapping.abort {},
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = false
        }),
        ["<Tab>"] = select_next,
        ["<S-Tab>"] = select_prev,
        ["<A-y>"] = require('minuet').make_cmp_map()
      },
      completion = {
        completeopt = "menuone,preview,noinsert",
      },
      sources = cmp.config.sources {
        -- { name = "nvim_lsp_signature_help" },
        -- { name = "cmp_tabnine", priority = 8 },
        { name = "nvim_lsp",    priority = 8 },
        { name = "ultisnips",   priority = 7 },
        { name = "luasnip",     keyword_length = 3, max_item_count = 3, priority = 7 },
        { name = "buffer",      priority = 7 },                                        -- first for locality sorting?
        { name = "spell",       keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
        { name = "dictionary",  keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] }, -- from uga-rosa/cmp-dictionary plug
        -- { name = 'rg'},
        { name = "nvim_lua",    priority = 5 },
        -- { name = 'path' },
        { name = "fuzzy_path",  priority = 4 }, -- from tzacher
        { name = "calc",        priority = 3 },
        -- { name = 'vsnip' },
        -- { name = "nvim_lsp", priority = 8 },
        -- { name = "nvim_lsp_signature_help" },
        -- -- { name = "copilot",                group_index = 2 },
        -- { name = "luasnip",                keyword_length = 3, max_item_count = 3 },
        -- { name = "buffer",                 priority = 7 },
        -- -- { name = "buffer",                 keyword_length = 5, max_item_count = 3, priority = 8 },
        -- { name = 'treesitter',             keyword_length = 5, max_item_count = 3 },
        -- { name = "nvim_lua",               group_index = 1 },
        -- { name = "lazydev",                group_index = 0 } -- set group index to 0 to skip loading LuaLS completions
      },
      sorting = {
        priority_weight = 1.0,
        comparators = {
          -- require("copilot_cmp.comparators").prioritize,
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight
          cmp.config.compare.offset,
          cmp.config.compare.order,
          -- cmp.config.compare.exact,
          -- cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          -- cmp.config.compare.length,
        },
      },
      formatting = {
        format = function(_, vim_item)
          local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 45, 50
          local ellipsis = icons.misc.ellipsis

          -- Add the icon.
          vim_item.kind = (symbol_kinds[vim_item.kind] or symbol_kinds.Text) .. ' ' .. vim_item.kind

          -- Truncate the label.
          if vim.api.nvim_strwidth(vim_item.abbr) > MAX_ABBR_WIDTH then
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_ABBR_WIDTH) .. ellipsis
          end

          -- Truncate the description part.
          if vim.api.nvim_strwidth(vim_item.menu or '') > MAX_MENU_WIDTH then
            vim_item.menu = vim.fn.strcharpart(vim_item.menu, 0, MAX_MENU_WIDTH) .. ellipsis
          end

          return vim_item
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      xperimental = {
        ghost_text = true,
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
      -- TODO decide how to complete, should enter be used ?
      mapping = cmp.mapping.preset.cmdline({
        ['<Down>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<Up>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<Right>'] = { c = cmp.mapping.abort {} },
        ['<CR>'] = { c = cmp.mapping.confirm {} },
        ["<C-/>"] = { c = cmp.mapping.abort {} }, -- TODO find better
      }),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
