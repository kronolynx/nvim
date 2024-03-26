return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  config = function()
    require('Comment').setup({
      toggler = {
        line = '<C-/>',
        block = '<C-S-/>'
      },
      opleader = {
        line = '<C-/>',
        block = '<C-S-/>',
      },
    })
  end
}
