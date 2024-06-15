return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  keys = {
    {
      "<leader>E",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "file manager (working directory)",
    },
    {
      "<leader>e",
      function()
        require("yazi").yazi(nil, vim.fn.expand('%:p:h'))
      end,
      desc = "file manager (file directory)",
    },
  },
  opts = {
    open_for_directories = false,
  },
}
