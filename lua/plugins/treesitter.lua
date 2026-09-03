vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' }
}, { confirm = false })

-- See `:help nvim-treesitter`
--
-- On the `main` branch nvim-treesitter only ships parsers, queries and
-- indents: there is no `configs.setup()`. Highlighting and folding come from
-- `vim.treesitter.start` / `vim.treesitter.foldexpr` in `core.autocmds`.

local parsers = {
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
}

require("nvim-treesitter-textobjects").setup({
  move = { set_jumps = true },
})

-- Jump between functions and classes. Registered up front rather than in the
-- deferred block below, so they are already live in the buffer that
-- `nvim {filename}` opens.
---@param fn "goto_next_start"|"goto_previous_start"
---@param query string
local function goto_textobj(fn, query)
  return function()
    require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
  end
end

local move_keys = {
  { "]f", "goto_next_start",     "@function.outer", "Next outer function" },
  { "]c", "goto_next_start",     "@class.outer",    "Next outer class" },
  { "[f", "goto_previous_start", "@function.outer", "Previous outer function" },
  { "[c", "goto_previous_start", "@class.outer",    "Previous outer class" },
}
for _, key in ipairs(move_keys) do
  local lhs, fn, query, desc = key[1], key[2], key[3], key[4]
  vim.keymap.set({ "n", "x", "o" }, lhs, goto_textobj(fn, query), { desc = desc })
end

-- Treesitter indentation, replacing the old `indent.enable` option. Only set
-- it where an `indents` query actually exists, otherwise indenting silently
-- falls back to returning -1 for every line.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_indent', { clear = true }),
  desc = 'Enable Treesitter indentation',
  callback = function(args)
    -- Skipped for yaml and big files, as on the old branch.
    if vim.bo[args.buf].filetype == 'yaml' or vim.b[args.buf].bigfile then
      return
    end

    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.query.get(lang, 'indents') then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Ensure Hocon files are recognized as hocon for syntax highlighting
local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead' },
  { group = hocon_group, pattern = '*/resources/*.conf', command = 'set ft=hocon' }
)

local function install_parsers()
  vim.defer_fn(function()
    if vim.fn.executable('tree-sitter') == 1 then
      require("nvim-treesitter").install(parsers)
    else
      vim.notify(
        'nvim-treesitter: `tree-sitter` CLI not found, parsers not installed',
        vim.log.levels.WARN
      )
    end
  end, 100)
end

-- On a fresh machine Mason may still be downloading the CLI, so wait for it
-- rather than failing once per parser. Registered synchronously here so the
-- listener is in place before MasonToolsReady can fire.
if vim.fn.executable('tree-sitter') == 1 then
  install_parsers()
else
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsReady',
    once = true,
    callback = install_parsers,
  })
end

vim.defer_fn(function()
  require("treesitter-context").setup({
    -- Avoid the sticky context from growing a lot.
    max_lines = 3,
    -- Match the context lines to the source code.
    multiline_threshold = 1,
    -- Disable it when the window is too small.
    min_window_height = 20,
  })
end, 100)
