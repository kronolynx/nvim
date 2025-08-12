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
    -- cond = true,
    enabled = false,
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
    'echasnovski/mini.clue',
    event = 'VeryLazy',
    enabled = false,
    opts = function()
      local miniclue = require 'mini.clue'

      -- Add a-z/A-Z marks.
      local function mark_clues()
        local marks = {}
        vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
        vim.list_extend(marks, vim.fn.getmarklist())

        return vim.iter(marks)
            :map(function(mark)
              local key = mark.mark:sub(2, 2)

              -- Just look at letter marks.
              if not string.match(key, '^%a') then
                return nil
              end

              -- For global marks, use the file as a description.
              -- For local marks, use the line number and content.
              local desc
              if mark.file then
                desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
              elseif mark.pos[1] and mark.pos[1] ~= 0 then
                local line_num = mark.pos[2]
                local lines = vim.fn.getbufline(mark.pos[1], line_num)
                if lines and lines[1] then
                  desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', ''))
                end
              end

              if desc then
                return { mode = 'n', keys = string.format('`%s', key), desc = desc }
              end
            end)
            :totable()
      end
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
          { mode = 'n', keys = '<leader>a',   desc = '+ai' },
          { mode = 'v', keys = '<leader>a',   desc = '+ai' },
          { mode = 'n', keys = '<leader>b',   desc = '+buffers' },
          { mode = 'n', keys = '<leader>c',   desc = '+code' },
          { mode = 'v', keys = '<leader>c',   desc = '+code' },
          { mode = 'n', keys = '<leader>d',   desc = '+diagnostics' },
          { mode = 'v', keys = '<leader>d',   desc = '+diagnostics' },
          { mode = 'n', keys = '<leader>g',   desc = '+goto' },
          { mode = 'n', keys = '<leader>h',   desc = '+http' },

          { mode = 'n', keys = '<leader>n',   desc = '+noice' },
          { mode = 'n', keys = '<leader>s',   desc = '+search' },
          { mode = 'v', keys = '<leader>s',   desc = '+search' },
          { mode = 'n', keys = '<leader>ss',  desc = '+symbol' },
          { mode = 'n', keys = '<leader>t',   desc = '+tabs' },
          { mode = 'n', keys = '<leader>q',   desc = '+quicklist' },

          { mode = 'n', keys = '<leader>w',   desc = '+walker' },
          { mode = 'n', keys = '<leader>ws',  desc = '+swap' },

          -- { mode = 'n', keys = '[',           desc = '+prev' },
          -- { mode = 'n', keys = ']',           desc = '+next' },
          -- Builtins.
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          -- Custom extras.
          mark_clues,
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
    -- TODO do I need this ?
    -- enabled = false,
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
    enabled = false,
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
}
