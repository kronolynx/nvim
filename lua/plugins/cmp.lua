return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- { 'hrsh7th/cmp-nvim-lsp-document-symbol'},
    -- TODO remove unused
    { "hrsh7th/cmp-emoji" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    { "saadparwaiz1/cmp_luasnip" },
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
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local cmp = require("cmp")
    local lspkind = require('lspkind')

    require("luasnip.loaders.from_vscode").lazy_load({ include = { "scala", "lua" } })
    require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/lua/snippets" })
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        -- None of this made sense to me when first looking into this since there
        -- is no vim docs, but you can't have select = true here _unless_ you are
        -- also using the snippet stuff. So keep in mind that if you remove
        -- snippets you need to remove this select
        ["<C-k"] = cmp.mapping.select_prev_item(),
        ["<C-j"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            -- cmp.confirm({ select = true })
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
      },
      completion = {
        completeopt = "menu,menuone,preview,noinsert,noselect",
      },
      sources = {
        { name = "nvim_lsp",                priority = 10 },
        { name = "nvim_lsp_document_symbol" },
        { name = "nvim_lsp_signature_help" },
        { name = "rg" }, --ripgrep results
        { name = "buffer" },
        --{ name = "look",                    keyword_length = 3, option = { convert_case = true, loud = true } },
        { name = "path" },
        { name = "nvim_lua" },
        { name = "luasnip" },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol',       -- show only symbol annotations
          maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

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
  end
}
