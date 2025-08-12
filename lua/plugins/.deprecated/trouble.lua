return {
  "folke/trouble.nvim",
  enabled = false,
  lazy = true,
  keys = {
    {
      "<leader>dw",
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      desc = "workspace diagnostics (Trouble)",
    },
    {
      "<leader>db",
      "<cmd>TroubleToggle document_diagnostics<cr>",
      desc = "buffer diagnostics (Trouble)",
    },
  },
  opts = {
    use_diagnostic_signs = true,
    auto_close = true,
  }
  -- -- TODO switch to beta when posible to close floatin preview when go to error
  -- lazy = true,
  -- branch = "dev", -- IMPORTANT!
  -- keys = {
  --   {
  --     "<leader>dt",
  --     "<cmd>Trouble diagnostics toggle<cr>",
  --     desc = "Diagnostics (Trouble)",
  --   },
  --   {
  --     "<leader>dT",
  --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  --     desc = "Buffer Diagnostics (Trouble)",
  --   },
  -- },
  -- -- opts = {}, -- for default options, refer to the configuration section for custom setup.
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- opts = {
  --   use_diagnostic_signs = true,
  --   focus = true,
  --   preview = { type = "float" },
  --   modes = {
  --     preview_float = {
  --       mode = "diagnostics",
  --       preview = {
  --         type = "float",
  --         relative = "editor",
  --         border = "rounded",
  --         title = "Preview",
  --         title_pos = "center",
  --       },
  --     },
  --   },
  -- },
}
