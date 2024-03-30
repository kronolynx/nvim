return {
  "folke/trouble.nvim",
  lazy = true,
  keys = {
    {
      "<leader>dt",
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>dT",
      "<cmd>TroubleToggle document_diagnostics<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
  },
  opts = {
    use_diagnostic_signs = true,
    auto_close = true,
  }
}
