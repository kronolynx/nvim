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

      -- -- Some builtin keymaps that I don't use and that I don't want mini.clue to show.
      -- for _, lhs in ipairs { '[%', ']%', 'g%' } do
      --   vim.keymap.del('n', lhs)
      -- end

      -- -- Add a-z/A-Z marks.
      -- local function mark_clues()
      --   local marks = {}
      --   vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
      --   vim.list_extend(marks, vim.fn.getmarklist())
      --
      --   return vim.iter.map(function(mark)
      --     local key = mark.mark:sub(2, 2)
      --
      --     -- Just look at letter marks.
      --     if not string.match(key, '^%a') then
      --       return nil
      --     end
      --
      --     -- For global marks, use the file as a description.
      --     -- For local marks, use the line number and content.
      --     local desc
      --     if mark.file then
      --       desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
      --     elseif mark.pos[1] and mark.pos[1] ~= 0 then
      --       local line_num = mark.pos[2]
      --       local lines = vim.fn.getbufline(mark.pos[1], line_num)
      --       if lines and lines[1] then
      --         desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', ''))
      --       end
      --     end
      --
      --     if desc then
      --       return { mode = 'n', keys = string.format('`%s', key), desc = desc }
      --     end
      --   end, marks)
      -- end


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
          -- Leader/movement groups.
          { mode = 'n', keys = '<leader>b',  desc = '+buffers' },
          { mode = 'n', keys = '<leader>c',  desc = '+code' },
          { mode = 'v', keys = '<leader>c',  desc = '+code' },
          { mode = 'n', keys = '<leader>co', desc = '+other' },
          { mode = 'n', keys = '<leader>d',  desc = '+debug' },
          { mode = 'n', keys = '<leader>k',  desc = '+copilot' },
          { mode = 'v', keys = '<leader>k',  desc = '+copilot' },
          { mode = 'n', keys = '<leader>g',  desc = '+goto' },
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
          add = 'sa',          -- Add surrounding in Normal and Visual modes
          delete = 'sd',       -- Delete surrounding
          find = 'sf',         -- Find surrounding (to the right)
          find_left = 'sF',    -- Find surrounding (to the left)
          highlight = 'sh',    -- Highlight surrounding
          replace = 'sr',      -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`

          suffix_last = 'l',   -- Suffix to search with "prev" method
          suffix_next = 'n',   -- Suffix to search with "next" method
        },
      })
    end
  }
}
