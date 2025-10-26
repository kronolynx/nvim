vim.pack.add({
  { src = "https://github.com/folke/flash.nvim" },
}, { confirm = false })

vim.defer_fn(function()
  require("flash").setup({
    jump = {
      -- automatically jump when there is only one match
      autojump = true,
    },
  })

  vim.keymap.set({ 'n', 'v' }, 's', function()
    require('flash').jump({
      search = { forward = true, wrap = false, multi_window = false },
    })
  end, { desc = 'select word forward' })

  vim.keymap.set({ 'n', 'v' }, 'S', function()
    require('flash').jump({
      search = { forward = false, wrap = false, multi_window = false },
    })
  end, { desc = 'select word backward' })

  vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function()
    require('flash').jump()
  end, { desc = 'Flash' })

  vim.keymap.set({ 'n', 'x', 'o' }, 'gS', function()
    require('flash').treesitter()
  end, { desc = 'Flash Treesitter' })

  vim.keymap.set('o', 'r', function()
    require('flash').remote()
  end, { desc = 'Remote Flash' })

  vim.keymap.set({ 'o', 'x' }, 'R', function()
    require('flash').treesitter_search()
  end, { desc = 'Treesitter Search' })

  vim.keymap.set('c', '<c-s>', function()
    require('flash').toggle()
  end, { desc = 'Toggle Flash Search' })

  vim.keymap.set('n', 'gl', function()
    require('flash').jump({
      labels = "asdfghjklqwertyuiopzxcvbnm;',.1234567890",
      search = {
        mode = 'search',
        max_length = 0,
        multi_window = false
      },
      label = { after = { 0, 0 } },
      pattern = '^'
    })
  end, { desc = 'select line' })

  vim.keymap.set('n', 'gw', function()
    require('flash').jump({
      pattern = vim.fn.expand('<cword>'),
    })
  end, { desc = 'select current word' })
end, 500)
