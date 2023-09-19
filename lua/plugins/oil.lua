return {
  "stevearc/oil.nvim",
  keys = {
    {"<leader>fe", "<cmd>Oil<CR>", desc = "Explorer" }
  },
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  opts = {},
  config = function ()
    require("oil").setup({})
  end
}
