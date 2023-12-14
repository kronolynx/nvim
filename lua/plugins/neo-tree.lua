return {
  "nvim-neo-tree/neo-tree.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>ft", "<cmd>Neotree toggle<CR>", desc = "Neotree toggle" },
    { "<leader>ff", "<cmd>Neotree reveal<CR>", desc = "Neotree toggle" }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
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
        hijack_netrw_behavior = "open_default"   -- "open_default", "open_current", "disabled",
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
