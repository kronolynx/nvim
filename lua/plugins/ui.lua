return {
  {
    "simrat39/symbols-outline.nvim",
    event = "VeryLazy",
    keys = { { "<leader>vo", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {},
  },
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = false },
    },
    keys = {
      { "<M-z>", "<cmd>WindowsMaximize<cr>", desc = "Zoom" },
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup({
        animation = { enable = false, duration = 150 },
      })
    end,
  },
  {
    "lewis6991/satellite.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = false -- only supports nvim 0.10
  },
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    "nvim-tree/nvim-tree.lua", -- increases hyperfine from ~47 to ~80
    lazy = false,
    enabled = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        disable_netrw = false,
        hijack_netrw = false,
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<CR>", desc = "Neotree toggle" },
      { "<leader>ff", "<cmd>Neotree reveal<CR>", desc = "Neotree toggle" }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      -- TODO determine if I want this or to configure in in default components, this is general so move it to options
      --vim.fn.sign_define("DiagnosticSignError",
      --  { text = " ", texthl = "DiagnosticSignError" })
      --vim.fn.sign_define("DiagnosticSignWarn",
      --  { text = " ", texthl = "DiagnosticSignWarn" })
      --vim.fn.sign_define("DiagnosticSignInfo",
      --  { text = " ", texthl = "DiagnosticSignInfo" })
      --vim.fn.sign_define("DiagnosticSignHint",
      --  { text = "󰌵", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        filesystem = {
          hijack_netrw_behavior = "disabled" -- "open_default", "open_current", "disabled",
        },
        default_component_configs = {
          name = {
            use_git_status_colors = false
          },
          diagnostics = {
            symbols = {
              hint = "󰌵",
              info = " ",
              warn = " ",
              error = "",
            },
            highlights = {
              hint = "DiagnosticSignHint",
              info = "DiagnosticSignInfo",
              warn = "DiagnosticSignWarn",
              error = "DiagnosticSignError",
            },
          },
        },
      })
    end
  }
}
