vim.pack.add({
  { src = 'https://github.com/aserowy/tmux.nvim' }
}, { load = true, confirm = false })

vim.defer_fn(function()
  require("tmux").setup()
end, 600)
