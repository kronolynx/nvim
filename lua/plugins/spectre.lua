return {
  "nvim-pack/nvim-spectre",
  build = false,
  lazy = true,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  -- stylua: ignore
  keys = {
    { "<leader>sR", function() require("spectre").open() end, desc = "replace in files (Spectre)" },
  },
}
