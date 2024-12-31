return {
  {
    'milanglacier/minuet-ai.nvim',
    enabled = true,
    config = function()
      require('minuet').setup {
        provider = 'codestral',
        provider_options = {
          codestral = {
            model = 'codestral-latest',
            end_point = 'https://api.mistral.ai/v1/fim/completions',
            api_key = "CODESTRAL_API_KEY",
            stream = false,
            optional = {
              stop = nil, -- the identifier to stop the completion generation
              max_tokens = nil,
            },
          },
        }
      }
    end
  },
  {
    "olimorris/codecompanion.nvim",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- The following are optional:
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    keys = {
      { "<leader>al", "<cmd>CodeCompanion<CR>",     desc = "Inline" },
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "openai",
          },
          inline = {
            adapter = "openai",
          },
        },
        opts = {
          stream = true,
          debug = true,
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "codestral",
              env = {
                url = "https://api.mistral.ai",
                api_key = "CODESTRAL_API_KEY",
                chat_url = "/v1/chat/completions"
              },
              handlers = {
                form_parameters = function(self, params, messages)
                  -- codestral doesn't support these in the body
                  params.stream_options = nil
                  params.options = nil

                  return params
                end,
              },
              schema = {
                model = {
                  default = "codestral-latest",
                },
                temperature = {
                  default = 0.2,
                  mapping = "parameters", -- not supported in default parameters.options
                },
              },
            })
          end,
        },
      })
    end
  },
  {
    "frankroeder/parrot.nvim",
    enabled = false,
    dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
    -- optionally include "rcarriga/nvim-notify" for beautiful notifications
    config = function()
      require("parrot").setup {
        -- Providers must be explicitly added to make them available.
        providers = {
          mistral = {
            api_key = os.getenv "OPEN_API_KEY",
            endpoint = "https://api.mistral.ai/v1",
            topic = {
              model = "codestral-latest",
              params = { max_tokens = 32 },
            },
          },
        },
      }
    end,
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      provider = 'openai',
      openai = {
        endpoint = "https://api.mistral.ai/v1",
        model = "codestral-latest",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = false,
    -- event = 'VeryLazy',
    event = "InsertEnter",
    config = function()
      -- local cmp = require 'cmp'
      -- local copilot = require 'copilot.suggestion'
      -- local luasnip = require 'luasnip'

      require("copilot").setup({
        -- filetypes = {
        --   ["*"] = true -- all files
        -- },
        panel = {
          enabled = false,
          -- auto_refresh = false,
          -- keymap = {
          --   jump_prev = "[[",
          --   jump_next = "]]",
          --   accept = "<CR>",
          --   refresh = "gr",
          --   open = "<C-x>"
          -- },
          -- layout = {
          --   position = "bottom", -- | top | left | right
          --   ratio = 0.4
          -- },
        },
        suggestion = {
          enabled = false,
          -- auto_trigger = true,
          -- keymap = {
          --   accept = "<M-A>",
          --   accept_word = "<M-w>",
          --   accept_line = "<M-a>",
          --   next = "<M-]>",
          --   prev = "<M-[>",
          --   dismiss = "/",
          --
          -- }
        }
      })

      -- ---@param trigger boolean
      -- local function set_trigger(trigger)
      --   if not trigger and copilot.is_visible() then
      --     copilot.dismiss()
      --   end
      --   vim.b.copilot_suggestion_auto_trigger = trigger
      --   vim.b.copilot_suggestion_hidden = not trigger
      -- end
      --
      -- -- Hide suggestions when the completion menu is open.
      -- cmp.event:on('menu_opened', function()
      --   set_trigger(false)
      -- end)
      -- cmp.event:on('menu_closed', function()
      --   set_trigger(not luasnip.expand_or_locally_jumpable())
      -- end)
    end
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   enabled = false,
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end
  -- },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
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
      { "<M-c>",      "<cmd>CopilotChatToggle<CR>",        desc = "copilot chat",           mode = "v" },
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
