return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  config = function()
    require 'marks'.setup {
      default_mappings = false,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = 1, -- { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      mappings = {
        set_next = "m,",
        next = "m]",
        prev = "m[",
        delete_line = "<leader>jd", -- TODO find how to add normally
        delete_buf = "<leader>jD",  -- Deletes all marks in current buffer
      }
    }
  end,
  keys = {
    { ';',          "<cmd>MarksListAll<cr>",     desc = "all" },
    { '<leader>jb', "<cmd>MarksListBuf<cr>",     desc = "buffer" },
    { '<leader>jg', "<cmd>MarksListGlobal<cr>",  desc = "global" },
    { '<leader>jt', "<cmd>MarksToggleSigns<cr>", desc = "toggle" },
  },
  -- opts = {},
}
