return {
  'rgroli/other.nvim',
  lazy = true,
  enabled = false,
  keys = {
    {
      "<leader>coo",
      "<cmd>Other<CR>",
      desc = "Open target file",
    },
    {
      "<leader>cov",
      "<cmd>OtherVSplit<CR>",
      desc = "Open target file in vertical split",
    },
    {
      "<leader>coh",
      "<cmd>OtherSplit<CR>",
      desc = "Open target file in horizontal split",
    },
    -- TODO add mapping that create the target file
  },
  config = function()
    require("other-nvim").setup({
      -- Should the window show files which do not exist yet based on
      -- pattern matching. Selecting the files will create the file.
      showMissingFiles = true,
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
