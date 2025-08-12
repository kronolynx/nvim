return {
  'echasnovski/mini.completion',
  enabled = false, -- too dificult to replace cmp
  lazy = "VeryLazy",
  config = function()
    require('mini.completion').setup({
      -- - `border` defines border (as in `nvim_open_win()`).
      window = {
        info = { height = 25, width = 80, border = 'rounded' },
        signature = { height = 25, width = 80, border = 'rounded' },
      },
    })
  end
}
