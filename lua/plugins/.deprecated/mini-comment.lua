return {
  "echasnovski/mini.comment",
  enabled = false,
  event = "VeryLazy",
  config = function()
    require('mini.comment').setup({
      options = {
        ignore_blank_line = true
      },
      mappings = {
        comment = 'gc',
        comment_line = 'gcc',
        comment_visual = 'gc',
        textobject = 'gc',
      },
    })
  end
}
