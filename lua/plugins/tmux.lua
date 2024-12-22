return {
  "aserowy/tmux.nvim",
  event = "VeryLazy",
  config = function()
    return require("tmux").setup (
    --   {
    --   -- TODO: Add resize keybindings
    --   navigation = {
    --     -- prevents unzoom tmux when navigating beyond vim border
    --     persist_zoom = true,
    --   },
    --   resize = {
    --     enable_default_keybindings = false,
    --   }
    -- }
    )
  end
}
