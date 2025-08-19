vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

return {
  'mistweaverco/kulala.nvim',
  ft = "http",
  keys = {
    { "<leader>hb", "<cmd>lua require('kulala').scratchpad()<cr>",  desc = "Open scratchpad",     ft = "http" },
    { "<leader>hs", "<cmd>lua require('kulala').run()<cr>",         desc = "Send the request",    ft = "http" },
    { "<leader>hi", "<cmd>lua require('kulala').inspect()<cr>",     desc = "Inspect request",     ft = "http" },
    { "<leader>ht", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle Body/headers", ft = "http" },
    { "<leader>hc", "<cmd>lua require('kulala').copy()<cr>",        desc = "Copy as curl",        ft = "http" },
    { "<leader>hp", "<cmd>lua require('kulala').from_curl()<cr>",   desc = "Paste from curl",     ft = "http" },
    {
      "<leader>hg",
      "<cmd>lua require('kulala').download_graphql_schema()<cr>",
      desc = "Download GraphQL schema",
      ft = "http",
    },
    { "<leader>hn", "<cmd>lua require('kulala').jump_next()<cr>",  desc = "Jump to next request",     ft = "http" },
    { "<leader>hp", "<cmd>lua require('kulala').jump_prev()<cr>",  desc = "Jump to previous request", ft = "http" },
    { "<leader>hq", "<cmd>lua require('kulala').close()<cr>",      desc = "Close window",             ft = "http" },
    { "<leader>hr", "<cmd>lua require('kulala').replay()<cr>",     desc = "Replay the last request",  ft = "http" },
    { "<leader>hS", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show stats",               ft = "http" },
  },
  opts = {
    winbar = true,
    default_view = "headers_body",
    split_direction = "horizontal",
    on_attach = function(bufnr) -- TODO this doesn't work
      vim.b[bufnr].miniclue_config = {
        clues = {
          { mode = 'n', keys = '<leader>h', desc = '+http' },
        },
      }
    end
  },
}
