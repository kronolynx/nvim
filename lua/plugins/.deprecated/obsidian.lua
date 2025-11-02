return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  enabled = false,
  -- TODO { ui = { enable = false } }
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    -- "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "~/Dropbox/Notes",
      },
    },
  },
}
