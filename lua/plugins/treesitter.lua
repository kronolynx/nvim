vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' }
}, { confirm = false })

-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require("nvim-treesitter.configs").setup({
    playground = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next outer function" },
          ["]c"] = { query = "@class.outer", desc = "Next outer class" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Previous outer function" },
          ["[c"] = { query = "@class.outer", desc = "Previous outer class" },
        },
      },
      -- swap = { -- TODO doesn't work with scala
      --   enable = true,
      --   swap_next = {
      --     ["<leader>wsl"] = { query = "@parameter.inner", desc = "Swap left"},
      --   },
      --   swap_previous = {
      --     ["<leader>wsh"] = { query = "@parameter.inner", desc = "Swap right"},
      --   },
      -- },
    },
    -- breaking changes announcements
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/2293
    -- ensure_installed = "all",
    ensure_installed = {
      -- "c",
      "bash",
      "diff",
      -- "dap_repl", -- not available, TODO find name
      "graphql",
      "fish",
      "haskell",
      "hocon",
      "html",
      "http",
      "java",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "scala",
      "smithy",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    disable = { "copilot-chat" },
    ignore_install = {},  -- List of parsers to ignore installing
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    highlight = {
      enable = true,      -- false will disable the whole extension
      disable = { "" },   -- list of language that will be disabled
    },
    indent = { enable = true, disable = { "yaml" } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-space>",
        node_incremental = "<M-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  })

  -- Ensure Hocon files are recognized as hocon for syntax highlighting
  local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
  vim.api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = hocon_group, pattern = '*/resources/*.conf', command = 'set ft=hocon' }
  )

  require("treesitter-context").setup({
    -- Avoid the sticky context from growing a lot.
    max_lines = 3,
    -- Match the context lines to the source code.
    multiline_threshold = 1,
    -- Disable it when the window is too small.
    min_window_height = 20,
  })
end, 100)
