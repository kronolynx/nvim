return {
  "numToStr/Comment.nvim",
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
