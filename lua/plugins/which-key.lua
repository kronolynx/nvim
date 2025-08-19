return {
  "folke/which-key.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    preset = "helix",
    sort = { "alphanum" },
    icons = {
      separator = "->",
      -- mappings = vim.g.have_nerd_font,
      mappings = false,
      keys = {},
    },
    spec = {
      { '<leader>a',  group = 'ai',           mode = { 'n', 'v' } },
      { '<leader>b',  group = 'buffers' },
      { '<leader>c',  group = 'code',         mode = { 'n', 'v' } },
      { '<leader>d',  group = 'diagnostics',  mode = { 'n', 'v' } },
      { '<leader>g',  group = 'goto' },
      { '<leader>h',  group = 'http' },

      { '<leader>n',  group = 'nofitications' },
      { '<leader>m',  group = 'git' },
      { '<leader>s',  group = 'search',       mode = { 'n', 'v' } },
      { '<leader>t',  group = 'tabs' },
      { '<leader>u',        group = 'utilities' },
      { '<leader>q',  group = 'quicklist' },

      { '<leader>w',  group = 'walker' },
      { '<leader>ws', group = 'swap' },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
