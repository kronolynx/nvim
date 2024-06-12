return {
  "NeogitOrg/neogit",
  lazy = true,
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional

    -- -- Only one of these is needed, not both.
    -- "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  config = true,
  keys = {
    { "<leader>mo", "<cmd>:Neogit cwd=%:p:h<CR>", desc = "open neogit" },
  }
}
