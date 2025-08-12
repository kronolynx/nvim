return {
  -- Plugin to search the web
  "aliqyan-21/wit.nvim",
  event = "VeryLazy",
  config = function()
    require('wit').setup({
      command_search = "Ws", --
      command_search_visual = "Wv",
      command_search_wiki = "Ww",
    })
  end
}
