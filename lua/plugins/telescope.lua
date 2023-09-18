return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
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
    -- local f = require("functions")
    -- local map = f.map
    -- map("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files({layout_strategy="vertical"})<CR>]])
    -- map("n", "<leader>lg", [[<cmd>lua require("telescope.builtin").live_grep({layout_strategy="vertical"})<CR>]])
    -- map("n", "<leader>gh", [[<cmd>lua require("telescope.builtin").git_commits({layout_strategy="vertical"})<CR>]])
    -- map("n", "<leader>mc", [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]])
    -- map("n", "<leader>cc", [[<cmd>lua RELOAD("telescope").extensions.coursier.complete()<CR>]])
    --
    -- map("n", "gds", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>]])
    -- map("n", "gws", [[<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>]])

    -- local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "target", "node_modules", "parser.c", "out", "%.min.js", "build", "logs" },
        prompt_prefix = "❯",
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        mappings = {
          n = {
            -- ["f"] = actions.send_to_qflist,
          },
        },
      },
    })

    require("telescope").load_extension("ui-select")
    -- require("telescope").load_extension("fzf")
    -- require("telescope").load_extension("file_browser")
  end
}
