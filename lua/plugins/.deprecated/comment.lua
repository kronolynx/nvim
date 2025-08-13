return {
  "numToStr/Comment.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require('Comment').setup({
      -- ignores empty lines
      ignore = '^$',
      toggler = {
        line = 'gcc',
        block = 'gbc'
      },
      opleader = {
        line = 'gc',
        block = 'gb',
      },
    })
  end
}
