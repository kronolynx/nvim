local icons = require("util.icons")

return {
  -- bread crumbs
  "utilyre/barbecue.nvim",
  event = "VeryLazy",
  name = "barbecue",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional dependency
    {
      "SmiteshP/nvim-navic",
      dependencies = "neovim/nvim-lspconfig",
      opts = {
        highlight = true,
        separator = " 〉",
        icons = icons.symbol_kinds
      },
    },
  },
  opts = {
    modifiers = {
      -- see :help filename-modifiers
      dirname = ":h:t"
    },
    show_basename = true,
    show_dirname = true,
  }
}
