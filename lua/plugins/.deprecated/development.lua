-- https://www.reddit.com/r/neovim/comments/v7yenx/comment/ibp92el
return {
  "milisims/nvim-luaref", -- builtin lua functions reference
  'folke/lua-dev.nvim',   -- nvim platform completion and LSP inline docs
  {
    'rafcamlet/nvim-luapad',
    keys = {
      -- TODO don't create a pad each time
      { "<F12>", "<cmd>Luapad<CR>" }
    }
  },
  {
    dir = "~/.config/nvim/dev/scratch-buffer",
    name = "scratch-buffer",
    enabled = false,
    opts = {
      title = "My scratchpad"
    }
  },
  {
    dir = "~/.config/nvim/dev/lightbulb",
    name = "lightbulb",
    enabled = false,
    config = function ()
      require("lightbulb")
    end
  }
}
