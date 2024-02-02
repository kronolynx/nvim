return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  opts = {
    history = true,                            -- enable history
    updateevents = "TextChanged,TextChangedI", -- update snippets on these events
    enable_autosnippets = true,
    delete_check_events = "TextChanged",
  },
  keys = function()
    return {}
  end,
  -- config = function()
  --   require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/lua/snippets" })
  -- end
}
