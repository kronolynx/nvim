return {
  {
    'milanglacier/minuet-ai.nvim',
    lazy = true,
    keys = {
      { "<leader>av", "<cmd>Minuet virtualtext toggle<CR>", desc = "Toggle virtual text" },
    },
    config = function()
      require('minuet').setup {
        provider = 'codestral',
        provider_options = {
          codestral = {
            model = 'codestral-latest',
            end_point = 'https://api.mistral.ai/v1/fim/completions',
            api_key = "CODESTRAL_API_KEY",
            stream = true,
            optional = {
              max_tokens = 256,
              stop = { '\n\n' },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            accept = '<A-A>',
            accept_line = '<A-a>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<A-n>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<A-p>',
            dismiss = '<A-e>',
          },
        },
      }
    end
  },
  {
    "olimorris/codecompanion.nvim",
    -- enabled = false,
    -- event = "VeryLazy",
    lazy = true,
    -- cmd = 'CodeCompanion',
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-treesitter/nvim-treesitter",
      -- The following are optional:
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    keys = {
      { "<leader>al", "<cmd>CodeCompanion<CR>",            desc = "Inline" },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat<CR>",
        mode = { 'n', 'v' },
        desc = "Chat"
      },
      { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
      { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>',    desc = 'Add to CodeCompanion chat', mode = 'x' },
    },
    opts = function()
      return {
        strategies = {
          chat = {
            adapter = "openai",
          },
          inline = {
            adapter = "openai",
            keymaps = {
              accept_change = {
                modes = { n = '<leader>ay' },
                description = 'Accept the suggested change',
              },
              reject_change = {
                modes = { n = '<leader>an' },
                description = 'Reject the suggested change',
              },
            },
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
      }
    end
  },
}
