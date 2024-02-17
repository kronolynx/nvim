return {
  "utilyre/barbecue.nvim",
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
        -- VScode-like icons
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        }
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
