vim.pack.add({
  { src = 'https://github.com/mikavilpas/yazi.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
}, { confirm = false })

vim.defer_fn(function()
  local yazi = require("yazi")
  yazi.setup({
    open_for_directories = true,
    -- highlight buffers in the same directory as the hovered buffer
    -- highlight_hovered_buffers_in_same_directory = false,
    highlight_groups = {
      hovered_buffer = { fg = 'none', bg = 'none' },
    },
    keymaps = {
      show_help = "<f1>",
    },
    integrations = {
      grep_in_directory = 'fzf-lua',
      grep_in_selected_files = 'fzf-lua',
    },
  })

  vim.keymap.set({ "n", "t" }, "<M-e>", function()
    yazi.yazi()
  end, { desc = "toggle yazi file explorer" })
  vim.keymap.set({ "n", "t" }, "<M-E>", function()
    yazi.toggle()
  end, { desc = "toggle yazi file explorer root" })
end, 150)
