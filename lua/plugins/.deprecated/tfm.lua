return {
  "rolv-apneseth/tfm.nvim",
  lazy = true,
  -- opts = {
  --   file_manager = "vifm"
  -- },
  keys = {
    {
      "<leader>fe",
      "<cmd>lua require('tfm').open()<CR>",
      desc = "TFM",
    },
  }
}
