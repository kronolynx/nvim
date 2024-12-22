return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "tokyonight-storm"
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
          blink_cmp = true,
          flash = true,
          gitsigns = true,
          mason = true,
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          mini = {
          enabled = true,
          indentscope_color = "lavender",
        },
          },
          indent_blankline = {
            enabled = true,
            scope_color = "lavender",      -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false, -- requires extra steps to enable
          },
          nvimtree = true,
          noice = true,
          notify = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          fzf = true,
          which_key = true,
        },
        highlight_overrides = {
          all = function(colors)
            return {
              Search = { bg = colors.surface1 },
              LineNr = { fg = colors.overlay0 },
              CursorLine = { bg = colors.surface0 },
              CursorColumn = { bg = colors.surface0 },
              IndentBlanklineChar = { fg = colors.mantle },
              Comment = { fg = colors.overlay1 },
            }
          end,
        },
      })

      vim.cmd.colorscheme "catppuccin-frappe"
    end
  },
}
