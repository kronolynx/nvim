return {
  -- Problems check https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#troubleshooting
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ':TSUpdate',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        -- Avoid the sticky context from growing a lot.
        max_lines = 3,
        -- Match the context lines to the source code.
        multiline_threshold = 1,
        -- Disable it when the window is too small.
        min_window_height = 20,
      },
      keys = {
        {
          '[c',
          function()
            -- Jump to previous change when in diffview.
            if vim.wo.diff then
              return '[c'
            else
              vim.schedule(function()
                require('treesitter-context').go_to_context()
              end)
              return '<Ignore>'
            end
          end,
          desc = 'Jump to upper context',
          expr = true,
        },
      },
    },
  },
  -- See `:help nvim-treesitter`
  -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
  config = vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
      playground = { enable = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      -- breaking changes announcements
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/2293
      -- ensure_installed = "all",
      ensure_installed = {
        "c",
        "bash",
        "diff",
        "dap_repl",
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
  end, 0)
}
