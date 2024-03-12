return {
  "anuvyklack/windows.nvim",
  event = "WinNew",
  dependencies = {
    { "anuvyklack/middleclass" },
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
}
