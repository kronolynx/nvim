return {
  "folke/flash.nvim",
  lazy = true,
  ---@type Flash.Config
  opts = {
  },
  -- stylua: ignore
  keys = {
    { "<leader><leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "flash" },
    { "<leader><leader>t", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "flash Treesitter" },
    { "<leader><leader>r", mode = "o",               function() require("flash").remote() end,     desc = "remote Flash" },
    -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    {
      "<leader><leader>l",
      mode = { "n" },
      function()
        require("flash").jump({
          labels = "asdfghjklqwertyuiopzxcvbnm;',.1234567890",
          search = {
            mode = "search",
            max_length = 0,
            multi_window = false
          },
          label = { after = { 0, 0 } },
          pattern = "^"
        })
      end,
      desc = "select line"
    },
    {
      "<leader><leader>j",
      function()
        require("flash").jump({
          search = { forward = true, wrap = false, multi_window = false },
        })
      end,
      desc = "select word forward"
    },
    {
      "<leader><leader>k",
      function()
        require("flash").jump({
          search = { forward = false, wrap = false, multi_window = false },
        })
      end,
      desc = "select word backward"
    },
    {
      "<leader><leader>w",
      function()
        require("flash").jump({
          search = { forward = true, wrap = false, multi_window = false },
          pattern = vim.fn.expand("<cword>"),
        })
      end,
      desc = "select current word"
    },
    {
      "<leader><leader>b",
      function()
        require("flash").jump({
          search = { forward = false, wrap = false, multi_window = false },
          pattern = vim.fn.expand("<cword>"),
        })
      end,
      desc = "select word backward"
    },
    {
      "<leader><leader>c",
      function()
        require("flash").jump({ continue = true })
      end,
      desc = "continue search"
    },
    {
      "<leader><leader>d",
      function()
        require("flash").jump({
          matcher = function(win)
            ---@param diag Diagnostic
            return vim.tbl_map(function(diag)
              return {
                pos = { diag.lnum + 1, diag.col },
                end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
              }
            end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
          end,
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              vim.diagnostic.open_float()
            end)
            state:restore()
          end,
        })
      end,
      desc = "diagnostic at target advanced"
    },
  }
}
