return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify"
  },
  -- stylua: ignore
  keys = {
    { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",           desc = "redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end,                                   desc = "last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end,                                desc = "history" },
    { "<leader>na", function() require("noice").cmd("all") end,                                    desc = "all" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "dismiss all" },
    { "<c-f>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,        expr = true,              desc = "scroll forward",  mode = { "i", "n", "s" } },
    { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,        expr = true,              desc = "scroll backward", mode = { "i", "n", "s" } },
  },
  config = function()
    require("noice").setup({
      -- cmdline = {
      --   -- view ="cmdline" -- "cmdline_popup"
      --   view = "cmdline_popup"
      -- },
      lsp = {
        progress = {
          enabled = false
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = false,
          silent = false -- set to true to not show a message if hover is not available
        },
        signature = {
          enabled = false
        },
        message = {
          enabled = false
        },
        documentation = {
          enabled = false
        },
      },
      status = {
        -- Statusline component for LSP progress notifications.
        lsp_progress = { event = 'lsp', kind = 'progress' },
      },
      routes = {
        -- Ignore `written` message
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        -- Ignore `undo` message
        {
          filter = { event = "msg_show", find = "^%d+ .*; before #%d+  %d+.*ago$" },
          opts = { skip = true },
        },
        -- Ignore `redo` message
        {
          filter = { event = "msg_show", find = "^%d+ .*; after #%d+  %d+.*ago$" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "^E486: Pattern not found:.*" },
          opts = { skip = true },
        },
        -- Don't show these in the default view.
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
          },
          opts = { skip = true },
        },
      },
      cmdline = {
        view = "cmdline"
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    })
  end
}
