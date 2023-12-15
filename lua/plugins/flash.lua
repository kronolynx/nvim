return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      mode = { "n" },
      function()
        require("flash").jump()
      end,
    },
    {
      "<leader>s",
      mode = { "v" },
      function()
        require("flash").jump()
      end,
    },
    {
      "S",
      mode = { "n" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter"
    },
    {
      "<leader><leader>l",
      mode = { "n" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = "^"
        })
      end
    },
    {
      "<leader><leader>w",
      mode = { "n" },
      function()
        require("flash").jump({
          pattern = ".", -- initialize pattern with any char
          search = {
            mode = function(pattern)
              -- remove leading dot
              if pattern:sub(1, 1) == "." then
                pattern = pattern:sub(2)
              end
              -- return word pattern and proper skip pattern
              return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
            end,
          },
          -- select the range
          jump = { pos = "range" },
        })
      end
    }
  },
}
