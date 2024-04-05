return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>mv", "<cmd>Gitsigns preview_hunk<CR>",              desc = "view hunk" },
    { "<leader>ms", "<cmd>Gitsigns stage_hunk<CR>",                desc = "stage hunk" },
    { "<leader>mr", "<cmd>Gitsigns reset_hunk<CR>",                desc = "reset hunk" },
    { "<leader>ms", "<cmd>Gitsigns stage_hunk<CR>",                mode = "v",            desc = "stage hunk" },
    { "<leader>mr", "<cmd>Gitsigns reset_hunk<CR>",                mode = "v",            desc = "reset hunk" },
    { "<leader>mn", "<cmd>Gitsigns next_hunk<CR>",                 desc = "next hunk" },
    { "<leader>mp", "<cmd>Gitsigns prev_hunk<CR>",                 desc = "previous hunk" },
    { "<leader>mV", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "View blame" },
    { "<leader>mS", "<cmd>Gitsigns stage_buffer<CR>",              desc = "stage buffer" },
    { "<leader>mR", "<cmd>Gitsigns reset_buffer<CR>",              desc = "reset buffer" },
  },
  opts = {
  },
  dependencies = 'nvim-lua/plenary.nvim',
}
