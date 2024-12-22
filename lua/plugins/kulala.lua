vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

return {
  'mistweaverco/kulala.nvim',
  ft = "http",
  keys = {
    { "<leader>hr", "<cmd>lua require('kulala').run()<cr>", desc = "Execute request" },
    { "<leader>hi", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect request" },
    { "<leader>ht", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle Body/headers" },
    { "<leader>hc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as curl" },
    { "<leader>hp", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from curl" },
  },
  opts = {
    winbar = true,
    default_view = "headers_body"
  },
}
