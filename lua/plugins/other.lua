return {
  'rgroli/other.nvim',
  lazy = true,
  keys = {
    {
      "<leader>oo",
      "<cmd>Other<CR>",
      desc = "Open target file",
    },
    {
      "<leader>ov",
      "<cmd>OtherVSplit<CR>",
      desc = "Open target file in vertical split",
    },
    {
      "<leader>oh",
      "<cmd>OtherSplit<CR>",
      desc = "Open target file in horizontal split",
    },
    -- TODO add mapping that created the target file
  },
  config = function()
    require("other-nvim").setup({
      -- Should the window show files which do not exist yet based on
      -- pattern matching. Selecting the files will create the file.
      showMissingFiles = false,
      style = {
        boder = "rounded",
      },
      mappings = {
        {
          pattern = '(.*)src/main/(.*).scala$',
          target = '%1src/test/%2Spec.scala',
          context = 'scala test'
        },
        {
          pattern = '(.*)src/test/(.*)Spec.scala$',
          target = '%1src/main/%2.scala',
          context = 'scala implementation'
        }
      }
    })
  end
}
