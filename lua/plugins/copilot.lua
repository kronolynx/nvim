return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local cmp = require 'cmp'
      local copilot = require 'copilot.suggestion'
      local luasnip = require 'luasnip'

      require("copilot").setup({
        filetypes = {
          ["*"] = true -- all files
        },
        panel = {
          enabled = false,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<C-x>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-A>",
            accept_word = "<M-w>",
            accept_line = "<M-a>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "/",

          }
        }
      })

      ---@param trigger boolean
      local function set_trigger(trigger)
        if not trigger and copilot.is_visible() then
          copilot.dismiss()
        end
        vim.b.copilot_suggestion_auto_trigger = trigger
        vim.b.copilot_suggestion_hidden = not trigger
      end

      -- Hide suggestions when the completion menu is open.
      cmp.event:on('menu_opened', function()
        set_trigger(false)
      end)
      cmp.event:on('menu_closed', function()
        set_trigger(not luasnip.expand_or_locally_jumpable())
      end)
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      window = {
        layout = 'float',
        border = 'rounded',
        width = 0.8,  -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal = '<C-l>',
          insert = '<C-l>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = 'gy',
        },
        show_diff = {
          normal = 'gd'
        },
        show_system_prompt = {
          normal = 'gp'
        },
        show_user_selection = {
          normal = 'gs'
        },
      },
    },
    keys = {
      { "<M-c>",      "<cmd>CopilotChatToggle<CR>",        desc = "copilot chat",           mode = "n" },
      { "<M-c>",      "<Esc><cmd>CopilotChatToggle<CR>",   desc = "copilot chat",           mode = "i" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>",       desc = "copilot explain",        mode = "v" },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>",           desc = "copilot fix",            mode = "v" },
      { "<leader>cd", "<cmd>CopilotChatFixDiagnostic<CR>", desc = "copilot fix diagnostic", mode = "v" },
      -- Show help actions with fzf-lua
      {
        "<leader>ch",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with fzf-lua
      {
        "<leader>cp",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    }
  },
}
