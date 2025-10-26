-- TODO how to ft=http ?
vim.pack.add({
  { src = "https://github.com/mistweaverco/kulala.nvim" },
}, { confirm = false })

vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'http', 'rest' },
  callback = function()
    require("kulala").setup({
      winbar = true,
      default_view = "headers_body",
      split_direction = "horizontal",
    })

    vim.keymap.set('n', '<leader>hb', '<cmd>lua require("kulala").scratchpad()<cr>', { desc = "Open scratchpad" })
    vim.keymap.set('n', '<leader>hs', '<cmd>lua require("kulala").run()<cr>', { desc = "Send the request" })
    vim.keymap.set('n', '<leader>hi', '<cmd>lua require("kulala").inspect()<cr>', { desc = "Inspect request" })
    vim.keymap.set('n', '<leader>ht', '<cmd>lua require("kulala").toggle_view()<cr>', { desc = "Toggle Body/headers" })
    vim.keymap.set('n', '<leader>hc', '<cmd>lua require("kulala").copy()<cr>', { desc = "Copy as curl" })
    vim.keymap.set('n', '<leader>hp', '<cmd>lua require("kulala").from_curl()<cr>', { desc = "Paste from curl" })
    vim.keymap.set('n', '<leader>hg', '<cmd>lua require("kulala").download_graphql_schema()<cr>',
      { desc = "Download GraphQL schema" })
    vim.keymap.set('n', '<leader>hn', '<cmd>lua require("kulala").jump_next()<cr>', { desc = "Jump to next request" })
    vim.keymap.set('n', '<leader>hp', '<cmd>lua require("kulala").jump_prev()<cr>', { desc = "Jump to previous request" })
    vim.keymap.set('n', '<leader>hq', '<cmd>lua require("kulala").close()<cr>', { desc = "Close window" })
    vim.keymap.set('n', '<leader>hr', '<cmd>lua require("kulala").replay()<cr>', { desc = "Replay the last request" })
    vim.keymap.set('n', '<leader>hS', '<cmd>lua require("kulala").show_stats()<cr>', { desc = "Show stats" })
  end
})

-- TODO how about filetype for which-key ?
-- vim.keymap.set('n', '<leader>hb', '<cmd>lua require("kulala").scratchpad()<cr>', { desc = "Open scratchpad", ft = "http" })
-- vim.keymap.set('n', '<leader>hs', '<cmd>lua require("kulala").run()<cr>', { desc = "Send the request", ft = "http" })
-- vim.keymap.set('n', '<leader>hi', '<cmd>lua require("kulala").inspect()<cr>', { desc = "Inspect request", ft = "http" })
-- vim.keymap.set('n', '<leader>ht', '<cmd>lua require("kulala").toggle_view()<cr>', { desc = "Toggle Body/headers", ft = "http" })
-- vim.keymap.set('n', '<leader>hc', '<cmd>lua require("kulala").copy()<cr>', { desc = "Copy as curl", ft = "http" })
-- vim.keymap.set('n', '<leader>hp', '<cmd>lua require("kulala").from_curl()<cr>', { desc = "Paste from curl", ft = "http" })
-- vim.keymap.set('n', '<leader>hg', '<cmd>lua require("kulala").download_graphql_schema()<cr>', { desc = "Download GraphQL schema", ft = "http" })
-- vim.keymap.set('n', '<leader>hn', '<cmd>lua require("kulala").jump_next()<cr>', { desc = "Jump to next request", ft = "http" })
-- vim.keymap.set('n', '<leader>hp', '<cmd>lua require("kulala").jump_prev()<cr>', { desc = "Jump to previous request", ft = "http" })
-- vim.keymap.set('n', '<leader>hq', '<cmd>lua require("kulala").close()<cr>', { desc = "Close window", ft = "http" })
-- vim.keymap.set('n', '<leader>hr', '<cmd>lua require("kulala").replay()<cr>', { desc = "Replay the last request", ft = "http" })
-- vim.keymap.set('n', '<leader>hS', '<cmd>lua require("kulala").show_stats()<cr>', { desc = "Show stats", ft = "http" })
