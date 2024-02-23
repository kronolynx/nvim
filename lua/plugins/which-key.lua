return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    defaults = {
      mode = { "n", "v" },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ["<leader>c"] = { name = "+[c]ode" },
      ["<leader>e"] = { name = "+[e]ditor" },
      ["<leader>f"] = { name = "+[f]ind" },
      ["<leader>g"] = { name = "+[g]oto" },
      ["<leader>h"] = { name = "+[h]arpoon" },
      ["<leader>l"] = { name = "+[l]SP" },
      ["<leader>lf"] = { name = "+[f]ind" },
      ["<leader>lg"] = { name = "+[g]oto" },
      ["<leader>lm"] = { name = "+[m]etals" },
      ["<leader>lv"] = { name = "+[v]iew" },
      ["<leader>m"] = { name = "+[m]agit" },
      ["<leader>mh"] = { name = "+[h]unk" },
      ["<leader>s"] = { name = "+[s]earch" },
      ["<leader>ss"] = { name = "+[s]ymbols" },
      ["<leader>v"] = { name = "+[v]iew" },
      ["<leader>vs"] = { name = "+[v]iew" },
    }
  },
  config = function(_, opts)
    local which_key = require("which-key")
    which_key.setup({
      plugins = {
        marks = true,     -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = true,  -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 9, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true,      -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true,      -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      -- -- add operators that will trigger motion and text object completion
      -- -- to enable all native operators, set the preset / operators plugin above
      -- operators = { gc = 'Comments' },
      icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = ' ', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
      },
      -- ➜  
      window = {
        border = 'none',          -- none, single, double, shadow
        position = 'bottom',      -- bottom, top
        margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 },                                             -- min and max height of the columns
        width = { min = 20, max = 50 },                                             -- min and max width of the columns
        spacing = 3,                                                                -- spacing between columns
        align = 'left',                                                             -- align columns left, center or right
      },
      ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
      hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
      show_help = true,                                                             -- show help message on the command line when the popup is visible
    })
    which_key.register(opts.defaults)
  end
}
