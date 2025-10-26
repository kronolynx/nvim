vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
}, { confirm = false })

vim.defer_fn(function()
  require("conform").setup({
    -- notify_on_error = false,
    -- Define your formatters
    formatters_by_ft = {
      c = { name = 'clangd', timeout_ms = 500, lsp_format = 'prefer' },
      javascript = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      javascriptreact = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      json = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      jsonc = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      less = { 'prettier' },
      lua = { "stylua" },
      markdown = { 'prettier' },
      python = { "isort", "black" },
      rust = { name = 'rust_analyzer', timeout_ms = 500, lsp_format = 'prefer' },
      -- scala = { "scalafmt" }, // already integrated in metals
      scss = { 'prettier' },
      sh = { "shfmt" },
      typescript = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      typescriptreact = { 'prettier', name = 'dprint', timeout_ms = 500, lsp_format = 'fallback' },
      yaml = { 'prettier' },
      -- For filetypes without a formatter:
      -- ['_'] = { 'trim_whitespace', 'trim_newlines' }, -- this breaks scala format
    },
    -- Set up format-on-save
    format_on_save = nil, -- { timeout_ms = 500, lsp_fallback = true },
    -- Customize formatters
    formatters = {
      injected = { options = { ignore_errors = true } },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  })
  --   init = function()
  --     -- If you want the formatexpr, here is the place to set it
  --     vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  --   end,
  -- }
  --

  vim.keymap.set("n", "<leader>=",
    function()
      require("conform").format({ async = true, lsp_fallback = true })
    end,
    { desc = "Format buffer" }
  )
end, 600)
