return {
  "gcmt/vessel.nvim",
  enabled = false,
  keys = {
    {'<leader>jm', "<cmd>VesselViewMarks<cr>", desc = "test"  },
  },
  event = "VeryLazy",
  config = function()
    require("vessel").setup({
      create_commands = true,
      commands = {
        view_marks = "Markss", -- you can customize each command name
        view_jumps = "Jumpss"
      }
    })
  end
}
