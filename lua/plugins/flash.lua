return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    cond = true,
    opts = {
      jump = {
        -- automatically jump when there is only one match
        autojump = true,
      },
    },
    keys = {
      {
        "s",
        function()
          require("flash").jump({
            search = { forward = true, wrap = false, multi_window = false },
          })
        end,
        desc = "select word forward"
      },
      {
        "S",
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
        desc = "select word backward"
      },
      { "gs",    mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "gS",    mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      {
        "gl",
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
        "gw",
        function()
          require("flash").jump({
            pattern = vim.fn.expand("<cword>"),
          })
        end,
        desc = "select current word"
      },
    },
  },
}
