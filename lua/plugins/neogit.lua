return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "nvim-telescope/telescope.nvim", -- optional
    "sindrets/diffview.nvim",        -- optional
  },
  config = true,
  keys = {
    { "<leader>mo",  "<cmd>:Neogit cwd=%:p:h<CR>",                desc = "open neogit" },
  }
}
