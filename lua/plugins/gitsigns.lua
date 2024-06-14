return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>mhv", "<cmd>Gitsigns preview_hunk<CR>",              desc = "view hunk" },
    { "<leader>mhs", "<cmd>Gitsigns stage_hunk<CR>",                desc = "stage hunk" },
    { "<leader>mhR", "<cmd>Gitsigns reset_hunk<CR>",                desc = "reset hunk" },
    { "<leader>mhs", "<cmd>Gitsigns stage_hunk<CR>",                desc = "stage hunk",   mode = "v" },
    { "<leader>mhR", "<cmd>Gitsigns reset_hunk<CR>",                desc = "reset hunk",   mode = "v" },
    { "<leader>mhn", "<cmd>Gitsigns next_hunk<CR>",                 desc = "next hunk" },
    { "<leader>mhp", "<cmd>Gitsigns prev_hunk<CR>",                 desc = "previous hunk" },
    { "<leader>mV",  "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "View blame" },
    { "<leader>mbs", "<cmd>Gitsigns stage_buffer<CR>",              desc = "stage buffer" },
    { "<leader>mbR", "<cmd>Gitsigns reset_buffer<CR>",              desc = "reset buffer" },
  },
  opts = {
  },
  dependencies = 'nvim-lua/plenary.nvim',
}
