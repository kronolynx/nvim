return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
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
  config = function(_, opts)
    require('luasnip').setup(opts)
    -- for friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    -- for custom snippets
    require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
  end,
}
