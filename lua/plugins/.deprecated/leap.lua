return {
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    cond = true,
    enabled = false,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap Forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap Backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    opts = {
      -- safe_labels = {} -- disable autojump
      preview_filter = function () return false end,
      case_sensitive = true
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "ggandor/flit.nvim",
    event = "VeryLazy",
    enabled = false,
    cond = true,
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" } }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  -- {
  --   "tpope/vim-repeat",
  --   cond = true,
  --   event = "VeryLazy"
  -- }
}
