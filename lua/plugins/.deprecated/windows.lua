return {
  "anuvyklack/windows.nvim",
  event = "WinNew",
  enabled = false,
  dependencies = {
    { "anuvyklack/middleclass" },
  },
  keys = {
    { "<M-z>", "<cmd>WindowsMaximize<cr>", desc = "Zoom" }, -- TODO not working in kitty
    { "<C-w>z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" },
  },
  config = function()
    vim.o.winwidth = 10
    vim.o.winminwidth = 10
    vim.o.equalalways = false
    require("windows").setup({
      animation = { enable = false, duration = 150 },
    })
  end,
}
