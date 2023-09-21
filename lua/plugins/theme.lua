return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme tokyonight-storm]]
    end,
    dependencies = {
      {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
          -- "SmiteshP/nvim-navic",
          "nvim-tree/nvim-web-devicons",
        },
        opts = {
          -- configurations go here
        }
      }
    }
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "catppuccin-frappe",
        integrations = {
          cmp = true,
          flash = true,
          gitsigns = true,
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          neotree = true,
          noice = true,
          notify = true,
          telescope = true,
          treesitter = true,
          ufo = true,
          which_key = true,
        }
      })

      vim.cmd.colorscheme "catppuccin-frappe"
    end
  },
}
