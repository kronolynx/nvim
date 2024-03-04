return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>mhv", "<cmd>Gitsigns preview_hunk<CR>",              desc = "preview" },
    { "<leader>mhs", "<cmd>Gitsigns stage_hunk<CR>",                desc = "stage" },
    { "<leader>mhr", "<cmd>Gitsigns reset_hunk<CR>",                desc = "reset" },
    { "<leader>mhs", "<cmd>Gitsigns stage_hunk<CR>", mode="v",      desc = "stage" },
    { "<leader>mhr", "<cmd>Gitsigns reset_hunk<CR>", mode="v",      desc = "reset" },
    { "<leader>mhn", "<cmd>Gitsigns next_hunk<CR>",                 desc = "next" },
    { "<leader>mhp", "<cmd>Gitsigns prev_hunk<CR>",                 desc = "previous" },
    { "<leader>mv",  "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "View blame" },
    { "<leader>mS",  "<cmd>Gitsigns stage_buffer<CR>",              desc = "stage buffer" },
    { "<leader>mR",  "<cmd>Gitsigns reset_buffer<CR>",              desc = "reset buffer" },
  },
  opts = {
  },
  dependencies = 'nvim-lua/plenary.nvim',
}
