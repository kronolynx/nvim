return {
  -- dir = "~/.config/nvim/dev/scratchpad",
  "kronolynx/scratchpad.nvim",
  -- name = "scratchpad",
  lazy = true,
  -- enabled = false,
  keys = {
    { "<M-S-n>", "<Cmd>ScratchpadToggle<CR>", mode = "n", { desc = "scratchpad toggle" } },
    { "<M-S-n>", "<Esc><Cmd>ScratchpadToggle<CR>", mode = "i", { desc = "scratchpad toggle" } },
  },
  opts = {
    title = "Notes",
    notes_dir = "~/Dropbox/Notes/scratch"
  }
}
