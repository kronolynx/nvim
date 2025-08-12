  return {
    'echasnovski/mini.misc',
    lazy = true,
    enabled = false,
    keys = {
      {
        "<leader>z", -- TODO try to replace windows with this ?
        function()
          require('mini.misc').zoom()
        end,
        desc = "zoom"
      },
    },
    config = function()
      require('mini.misc').setup()
    end
  }
