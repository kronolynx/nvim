return {
  {
    'echasnovski/mini.align',
    lazy = true,
    config = function()
      require('mini.align').setup()
    end
  },
  {
    -- Only for cursor animation
    'echasnovski/mini.animate',
    event = "VeryLazy",
    config = function()
      require('mini.animate').setup(
        {
          scroll = {
            enable = false,
          },
          resize = {
            enable = false,
          },
          open = {
            enable = false,
          },
          close = {
            enable = false,
          },
        }
      )
    end
  },
  {
    'echasnovski/mini.bufremove',
    config = true,
    lazy = true,
    keys = {
      {
        '<leader>td',
        function()
          require('mini.bufremove').delete(0, false)
        end,
        desc = 'delete',
      },
    }
  },
  {
    'echasnovski/mini.clue',
    event = 'VeryLazy',
    opts = function()
      local miniclue = require 'mini.clue'

      -- Clues for recorded macros.
      local function macro_clues()
        local res = {}
        for _, register in ipairs(vim.split('abcdefghijklmnopqrstuvwxyz', '')) do
          local keys = string.format('"%s', register)
          local ok, desc = pcall(vim.fn.getreg, register, 1)
          if ok and desc ~= '' then
            table.insert(res, { mode = 'n', keys = keys, desc = desc })
            table.insert(res, { mode = 'v', keys = keys, desc = desc })
          end
        end

        return res
      end

      return {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },

          -- Moving between stuff.
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },
        },
        clues = {
          { mode = 'n', keys = '<leader>a',  desc = '+ai' },
          { mode = 'v', keys = '<leader>a',  desc = '+ai' },
          { mode = 'n', keys = '<leader>b',  desc = '+buffers' },
          { mode = 'n', keys = '<leader>c',  desc = '+code' },
          { mode = 'v', keys = '<leader>c',  desc = '+code' },
          { mode = 'n', keys = '<leader>d',  desc = '+diagnostics' },
          { mode = 'v', keys = '<leader>d',  desc = '+diagnostics' },
          { mode = 'n', keys = '<leader>g',  desc = '+goto' },
          { mode = 'n', keys = '<leader>h',  desc = '+http' },
          { mode = 'n', keys = '<leader>j',  desc = '+jump (flash)' },
          { mode = 'n', keys = '<leader>l',  desc = '+lsp' },
          { mode = 'v', keys = '<leader>l',  desc = '+lsp' },
          { mode = 'n', keys = '<leader>ld', desc = '+debug' },
          { mode = 'n', keys = '<leader>lv', desc = '+view' },
          -- GIT
          { mode = 'n', keys = '<leader>m',  desc = '+git' },
          { mode = 'v', keys = '<leader>m',  desc = '+git' },
          { mode = 'n', keys = '<leader>mh', desc = '+hunk' },
          { mode = 'v', keys = '<leader>mh', desc = '+hunk' },
          { mode = 'n', keys = '<leader>mb', desc = '+buffer' },
          { mode = 'v', keys = '<leader>mb', desc = '+buffer' },

          { mode = 'n', keys = '<leader>n',  desc = '+noice' },
          { mode = 'n', keys = '<leader>s',  desc = '+search' },
          { mode = 'n', keys = '<leader>ss', desc = '+symbol' },
          { mode = 'n', keys = '<leader>t',  desc = '+tabs' },
          { mode = 'n', keys = '<leader>q',  desc = '+quicklist' },

          { mode = 'n', keys = '<leader>w',  desc = '+walker' },
          { mode = 'n', keys = '<leader>ws', desc = '+swap' },
          -- Builtins.
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          -- Custom extras.
          -- mark_clues,
          macro_clues,
        },
        window = {
          delay = 500,
          -- todo unify all scrolls
          scroll_down = '<C-d>',
          scroll_up = '<C-u>',
          config = function(bufnr)
            local max_width = 0
            for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
              max_width = math.max(max_width, vim.fn.strchars(line))
            end

            -- Keep some right padding.
            max_width = max_width + 2

            return {
              border = 'rounded',
              -- Dynamic width capped at 45.
              width = math.min(45, max_width),
            }
          end,
        },
      }
    end,
  },
  {
    'echasnovski/mini.hipatterns',
    event = 'BufReadPost',
    opts = function()
      local highlighters = {}
      for _, word in ipairs { 'todo', 'note', 'hack' } do
        highlighters[word] = {
          pattern = string.format('%%f[%%w]()%s()%%f[%%W]', word:upper()),
          group = string.format('MiniHipatterns%s', word:sub(1, 1):upper() .. word:sub(2)),
        }
      end

      return { highlighters = highlighters }
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "nvimtree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "fzf",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    'echasnovski/mini.surround',
    event = "VeryLazy",
    enabled = true,
    config = function()
      require('mini.surround').setup({
        mappings = {
          add = 'sa',            -- Add surrounding in Normal and Visual modes
          delete = 'sd',         -- Delete surrounding
          find = 'sf',           -- Find surrounding (to the right)
          find_left = 'sF',      -- Find surrounding (to the left)
          highlight = 'sh',      -- Highlight surrounding
          replace = 'sr',        -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`

          suffix_last = 'l',     -- Suffix to search with "prev" method
          suffix_next = 'n',     -- Suffix to search with "next" method
        },
      })
    end
  }
}
