vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
}, { load = true, confirm = false })

vim.defer_fn(function()
  require("render-markdown").setup({
    file_types = { "markdown", "codecompanion" },
    completions = { lsp = { enabled = true } },
    render_modes = true
  })
end, 500)
