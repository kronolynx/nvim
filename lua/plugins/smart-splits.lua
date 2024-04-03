return {
  'mrjones2014/smart-splits.nvim',
  lazy = true,
  keys = {
    { "<M-,>",     "<cmd>lua require('smart-splits').resize_left()<CR>" },
    { "<M-.>",     "<cmd>lua require('smart-splits').resize_right()<CR>" },
    { "<M-lt>",    "<cmd>lua require('smart-splits').resize_up()<CR>" },
    { "<M->>",     "<cmd>lua require('smart-splits').resize_down()<CR>" },
    { "<M-Left>",  "<cmd>lua require('smart-splits').move_cursor_left()<CR>" },
    { "<M-Right>", "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
    { "<M-Up>",    "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
    { "<M-Down>",  "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
  },
  config = function()
    require("smart-splits").setup({
      at_edge = "wrap",
      multiplexer_integration = "tmux",
      ignored_filetypes = { 'NeoTree' },
    })
  end
}
