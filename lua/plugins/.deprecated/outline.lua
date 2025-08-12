return {
  "hedyhli/outline.nvim",
  lazy = true,
  enabled = false,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>cvs", "<cmd>Outline<CR>", desc = "[s]ymbols outline" },
  },
  opts = {
    outline_window = {
      position = 'right',
      -- Percentage or integer of columns
      width = 20,
      -- Whether width is relative to the total width of nvim
      -- When relative_width = true, this means take 25% of the total
      -- screen width for outline window.
      relative_width = true,
      -- Auto close the outline window if goto_location is triggered and not for
      -- peek_location
      auto_close = true,
    }
  },
}
