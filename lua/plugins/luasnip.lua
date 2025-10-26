vim.pack.add({
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/L3MON4D3/LuaSnip', build = 'make install_jsregexp' }
}, { load = true, confirm = false })


vim.defer_fn(function()
  require('luasnip').setup({
    history = true,                            -- enable history
    updateevents = "TextChanged,TextChangedI", -- update snippets on these events
    enable_autosnippets = true,
    delete_check_events = "TextChanged",
  })

  -- for friendly snippets
  require("luasnip.loaders.from_vscode").lazy_load()
  -- for custom snippets
  require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
end, 500)
