return {
  -- {
  --   "vhyrro/luarocks.nvim",
  --   enabled = false,
  --   lazy = true,
  --   -- branch = "go-away-python",
  --   -- config = function()
  --   --   require("luarocks").setup({})
  --   -- end,
  --   config = true,
  --   opts = {
  --     rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
  --   }
  -- },
  {
    "rest-nvim/rest.nvim",
    enabled = false,
    lazy = true,
    ft = "http",
    opts = {
      rocks = {
        hererocks = true
      }
    }
    -- dependencies = { "luarocks.nvim" },
    -- config = function()
    --   require("rest-nvim").setup({
    --     result = {
    --       split = {
    --         horizontal = true,
    --         in_place = false,
    --         stay_in_current_window_after_split = true,
    --       }
    --     }
    --   })
    --
    -- end,
  }
}
