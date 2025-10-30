vim.pack.add({
  { src = "https://github.com/milanglacier/minuet-ai.nvim" },
  { src = "https://github.com/olimorris/codecompanion.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },                    -- required by code companion
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" } -- ft = { "markdown", "codecompanion" } },
  -- { src = "https://github.com/zbirenbaum/copilot.lua" }
}, { confirm = false })

vim.defer_fn(function()
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

  vim.keymap.set('n', '<leader>av', '<cmd>Minuet virtualtext toggle<CR>', { desc = 'Toggle virtual text' })

  require('codecompanion').setup(
    {
      strategies = {
        chat = {
          -- adapter = "copilot",
          adapter = "openai",
          opts = {
            completion_provider = "blink", -- blink|cmp|coc|default
          },
        },
        inline = {
          -- adapter = "copilot",
          adapter = "openai",
        },
        agent = {
          -- adapter = "copilot",
          adapter = "openai",
        },
        -- inline = {
        --   adapter = "openai",
        --   keymaps = {
        --     accept_change = {
        --       modes = { n = '<leader>ay' },
        --       description = 'Accept the suggested change',
        --     },
        --     reject_change = {
        --       modes = { n = '<leader>an' },
        --       description = 'Reject the suggested change',
        --     },
        --   },
        -- },
      },
      opts = {
        stream = true,
        debug = true,
      },
      adapters = {
        http = {
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
      },
    })
  vim.keymap.set({ "n", "v" }, "<leader>ak", "<cmd>CodeCompanionActions<CR>", { desc = "AI actions" })
  vim.keymap.set('n', '<leader>al', '<cmd>CodeCompanion<CR>', { desc = 'Inline' })
  vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = 'Chat' })
  vim.keymap.set('n', '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion chat' })
  vim.keymap.set('x', '<leader>aa', '<cmd>CodeCompanionChat Add<CR>', { desc = 'Add to CodeCompanion chat' })
  vim.keymap.set({ "n", "v" }, "<leader>ai", function()
    local mode = vim.fn.mode()
    vim.ui.input({ prompt = "Ask AI 󱙺 ", win = { style = "above_cursor" } }, function(input)
      if input and input ~= "" then
        if mode:match("[vV\22]") then
          vim.cmd("'<,'>CodeCompanion " .. input)
        else
          vim.cmd("CodeCompanion " .. input)
        end
      end
    end)
  end, { desc = "AI inline assistant" })

  -- require("copilot").setup({
  --   -- filetypes = {
  --   --   ["*"] = true -- all files
  --   -- },
  --   panel = {
  --     enabled = false,
  --     -- auto_refresh = false,
  --     -- keymap = {
  --     --   jump_prev = "[[",
  --     --   jump_next = "]]",
  --     --   accept = "<CR>",
  --     --   refresh = "gr",
  --     --   open = "<C-x>"
  --     -- },
  --     -- layout = {
  --     --   position = "bottom", -- | top | left | right
  --     --   ratio = 0.4
  --     -- },
  --   },
  --   suggestion = {
  --     enabled = false,
  --     -- auto_trigger = true,
  --     -- keymap = {
  --     --   accept = "<M-A>",
  --     --   accept_word = "<M-w>",
  --     --   accept_line = "<M-a>",
  --     --   next = "<M-]>",
  --     --   prev = "<M-[>",
  --     --   dismiss = "/",
  --     --
  --     -- }
  --   }
  -- })
end, 500)
