return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>mv", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
    { "<leader>ms", "<cmd>Gitsigns stage_hunk<CR>" },
    { "<leader>mr", "<cmd>Gitsigns reset_hunk<CR>" },
    { "<leader>mn", "<cmd>Gitsigns next_hunk<CR>" },
    { "<leader>mp", "<cmd>Gitsigns prev_hunk<CR>" },
    { "<leader>mb", "<cmd>Gitsigns toggle_current_line_blame<CR>" }
  },
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitsigns').setup()
  end,
}
