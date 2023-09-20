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
    { "<leader>sp", "<cmd>Telescope live_grep<CR>" } -- search in path
  },
  config = function()
    require("telescope").load_extension("ui-select")
  end
}
