return {
  "jiaoshijie/undotree",
  lazy = true,
  config = true,
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
  },
}
