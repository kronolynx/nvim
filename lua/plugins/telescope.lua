return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = { "kkharji/sqlite.lua" }
    },
  },
  keys = {
    { "<leader>gf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>tr", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    { "<leader>bs", "<cmd>Telescope marks<CR>",      desc = "Marks" },
    { "<leader>xk", "<cmd>Telescope keymaps<CR>",    desc = "Keymaps" },
    { "<leader>ml", "<cmd>Telescope git_commits<CR>" },
    { "<leader>fp", "<cmd>Telescope live_grep<CR>" }, -- find in path
    { "<leader>sp", "<cmd>Telescope live_grep<CR>" }  -- search in path
  },
  config = function()
    local action_layout = require("telescope.actions.layout")
    require("telescope").load_extension("ui-select")
    require("telescope").setup({
      pickers = {
        buffers = {
          sort_mru = true,
        }
      },
      mappings = {
        n = {
          ["<M-p>"] = action_layout.toggle_preview
        },
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key",
          ["<M-p>"] = action_layout.toggle_preview
        }
      }
    })
  end
}
