return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-refactor',
  },
  config = function()
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
        "bash",
        "html",
        "haskell",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        -- "query",
        "regex",
        "scala",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
      sync_install = false,          -- install languages synchronously (only applied to `ensure_installed`)
      highlight = {
        enable = true,               -- false will disable the whole extension
        disable = { "" },            -- list of language that will be disabled
      },
      indent = { enable = true, disable = { "yaml" } }
    })
  end
}
