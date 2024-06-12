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
    { "<M-S-Left>",  "<cmd>lua require('smart-splits').swap_buf_left()<CR>" },
    { "<M-S-Right>", "<cmd>lua require('smart-splits').swap_buf_right()<CR>" },
    { "<M-S-Up>",    "<cmd>lua require('smart-splits').swap_buf_up()<CR>" },
    { "<M-S-Down>",  "<cmd>lua require('smart-splits').swap_buf_down()<CR>" },
    { "<C-S-h>",  "<cmd>lua require('smart-splits').swap_buf_left()<CR>" },
    { "<C-S-l>", "<cmd>lua require('smart-splits').swap_buf_right()<CR>" },
    { "<C-S-k>",    "<cmd>lua require('smart-splits').swap_buf_up()<CR>" },
    { "<C-S-j>",  "<cmd>lua require('smart-splits').swap_buf_down()<CR>" },
  },
  config = function()
    require("smart-splits").setup({
      at_edge = "wrap",
      ignored_filetypes = { 
        'NvimTree',
      },
    })
  end
}
