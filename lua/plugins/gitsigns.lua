return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>mhv", "<cmd>Gitsigns preview_hunk<CR>",              desc = "Preview" },
    { "<leader>mhs", "<cmd>Gitsigns stage_hunk<CR>",                desc = "Stage" },
    { "<leader>mhr", "<cmd>Gitsigns reset_hunk<CR>",                desc = "Reset" },
    { "<leader>mhn", "<cmd>Gitsigns next_hunk<CR>",                 desc = "Next" },
    { "<leader>mhp", "<cmd>Gitsigns prev_hunk<CR>",                 desc = "Previous" },
    { "<leader>mv",  "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "view blame" },
    { "<leader>ms",  "<cmd>Gitsigns stage_buffer<CR>",              desc = "Stage buffer" },
    { "<leader>mr",  "<cmd>Gitsigns stage_buffer<CR>",              desc = "Reset buffer" },
  },
  opts = {
  },
  dependencies = 'nvim-lua/plenary.nvim',
}
