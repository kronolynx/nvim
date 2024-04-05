return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          ["*"] = true -- all files
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = false,
            accept_word = "<M-Right>",
            accept_line = "<M-Up>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-c>"
          }
        }
      })
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
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<CR>",        desc = "copilot chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>",       desc = "copilot explain",       mode = "v" },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>",           desc = "copilot fix" },
      { "<leader>cd", "<cmd>CopilotChatFixDiagnostic<CR>", desc = "copilot fix diagnostic" }
    }
  },
}
