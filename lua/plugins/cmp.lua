return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- { 'hrsh7th/cmp-nvim-lsp-document-symbol'},
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    { "lukas-reineke/cmp-under-comparator" },
    { "onsails/lspkind.nvim" },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end
    },
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require('lspkind')

    cmp.setup({
      snippet = {
        expand = function(args)
          -- Comes from vsnip
          vim.fn["vsnip#anonymous"](args.body)
          -- require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        -- None of this made sense to me when first looking into this since there
        -- is no vim docs, but you can't have select = true here _unless_ you are
        -- also using the snippet stuff. So keep in mind that if you remove
        -- snippets you need to remove this select
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      sources = {
        { name = "nvim_lsp",               priority = 10 },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "look",                   keyword_length = 3, option = { convert_case = true, loud = true } },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
      },
      formatting = {
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',         -- show only symbol annotations
            maxwidth = 50,           -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...',   -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              return vim_item
            end
          })
        }
      }
    })
  end
}
