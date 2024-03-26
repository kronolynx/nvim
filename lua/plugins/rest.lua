return {
  {
    "vhyrro/luarocks.nvim",
    lazy = true,
    branch = "go-away-python",
    config = function()
      require("luarocks").setup({})
    end,
  },
  {
    "rest-nvim/rest.nvim",
    lazy = true,
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup({
        result = {
          split = {
            horizontal = true,
            in_place = false,
            stay_in_current_window_after_split = true,
          }
        }
      })
    end,
  }
}
