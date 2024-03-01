return {
  'mrjones2014/smart-splits.nvim',
  keys = {
    { "<A-,>",  "<cmd>lua require('smart-splits').resize_left()<CR>" },
    { "<A-.>",  "<cmd>lua require('smart-splits').resize_right()<CR>" },
    { "<A-lt>", "<cmd>lua require('smart-splits').resize_up()<CR>" },
    { "<A->>",  "<cmd>lua require('smart-splits').resize_down()<CR>" },
    { "<A-Left>",  "<cmd>lua require('smart-splits').move_cursor_left()<CR>" },
    { "<A-Right>",  "<cmd>lua require('smart-splits').move_cursor_right()<CR>" },
    { "<A-Up>", "<cmd>lua require('smart-splits').move_cursor_up()<CR>" },
    { "<A-Down>",  "<cmd>lua require('smart-splits').move_cursor_down()<CR>" },
  },
  config = function()
    require("smart-splits").setup({
      at_edge = "wrap",
      multiplexer_integration = "tmux",
      ignored_filetypes = { 'NeoTree' },
    })
    -- map("n", "<A-,>", "<cmd>vertical res -3<cr>")
    -- map("n", "<A-.>", "<cmd>vertical res +3<cr>")
    -- map("n", "<A-lt>", "<cmd>horizontal res -3<cr>")
    -- map("n", "<A-gt> ", "<cmd>horizontal res +3<cr>") -- TODO fix me
  end
}
