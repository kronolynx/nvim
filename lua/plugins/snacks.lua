-- for debugging
-- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
_G.dd              = function(...)
  Snacks.debug.inspect(...)
end
_G.bt              = function()
  Snacks.debug.backtrace()
end
vim.print          = _G.dd

local gitbrowse    = {
  -- what = "permalink",
  url_patterns = {
    ["github%.com"] = {
      branch = "/tree/{branch}",
      file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
      permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
      commit = "/commit/{commit}",
    },
    ["gitlab%.com"] = {
      branch = "/-/tree/{branch}",
      file = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
      permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
      commit = "/-/commit/{commit}",
    },
    -- ["gitlab.evolution%.com"] = {
    --   branch = "/-/tree/{branch}",
    --   file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
    --   permalink = "/-/blob/{commit}/{file}#L{line_start}-L{line_end}",
    --   commit = "/-/commit/{commit}",
    -- },
    ["bitbucket%.org"] = {
      branch = "/src/{branch}",
      file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
      permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
      commit = "/commits/{commit}",
    },
    ["git.sr.ht"] = {
      branch = "/tree/{branch}",
      file = "/tree/{branch}/item/{file}",
      permalink = "/tree/{commit}/item/{file}#L{line_start}",
      commit = "/commit/{commit}",
    },
  }
}

local indent       = {
  enabled = true,
  scope = {
    hl = "SnacksDashboardTerminal",
    priority = 200,
    char = "│",
    underline = false,   -- underline the start of the scope
    only_current = true, -- only show scope in the current window
  },
}

local dashboard    = {
  enabled = false
  -- sections = {
  --   { section = "header" },
  --   { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
  --   { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
  --   { section = "startup" },
  -- },
}

local my_layout    = {
  layout = {
    box = "vertical",
    backdrop = false,
    width = 0.8,
    min_width = 120,
    height = 0.9,
    {
      win = "preview",
      title = "{preview}",
      border = "rounded",
      height = 0.6,
    },
    {
      box = "vertical",
      border = "rounded",
      -- height = 0.,
      title = "{title} {live} {flags}",
      { win = "input", height = 1,     border = "bottom" },
      { win = "list",  border = "none" },
    },
  }
}

local picker       = {
  matcher = {
    frecency = true,      -- frecency bonus
    history_bonus = true, -- give more weight to chronological order
  },
  formatters = {
    file = {
      filename_first = true,
      truncate = 200
    },
  },
  ui_select = true, -- replace `vim.ui.select` with the snacks picker
  sources = {
    explorer = {
      auto_close = true,
      include = { ".metals" },
      formatters = {
        file = { filename_only = true },
        severity = { pos = "right" },
      },
      layout = {
        preset = "sidebar",
        preview = "main",
        layout = {
          width = 60, -- TODO set with to match text
          -- width = 0.3
        },
      },
    },
    autocmds = { layout = my_layout },
    buffers = { layout = my_layout },
    cliphist = { layout = my_layout },
    colorschemes = { layout = my_layout },
    command_history = { layout = my_layout },
    commands = { layout = my_layout },
    diagnostics = { layout = my_layout },
    diagnostics_buffer = { layout = my_layout },
    files = { layout = my_layout },
    git_branches = { layout = my_layout },
    git_files = { layout = my_layout },
    git_grep = { layout = my_layout },
    git_log = { layout = my_layout },
    git_log_file = { layout = my_layout },
    git_log_line = { layout = my_layout },
    git_stash = { layout = my_layout },
    git_status = { layout = my_layout },
    git_diff = { layout = my_layout },
    grep = { layout = my_layout },
    grep_buffers = { layout = my_layout },
    grep_word = { layout = my_layout },
    help = { layout = my_layout },
    highlights = { layout = my_layout },
    -- icons = { layout = my_layout },
    jumps = { layout = my_layout },
    keymaps = { layout = my_layout },
    lazy = { layout = my_layout },
    -- lines = { layout = my_layout },
    loclist = { layout = my_layout },
    lsp_config = { layout = my_layout },
    lsp_declarations = { layout = my_layout },
    lsp_definitions = { layout = my_layout },
    lsp_implementations = { layout = my_layout },
    lsp_references = { layout = my_layout },
    lsp_symbols = { layout = my_layout },
    lsp_workspace_symbols = { layout = my_layout },
    lsp_type_definitions = { layout = my_layout },
    man = { layout = my_layout },
    marks = { layout = my_layout },
    -- notifications = { layout = my_layout },
    -- pickers = { layout = my_layout },
    -- picker_actions = { layout = my_layout },
    -- picker_format = { layout = my_layout },
    -- picker_layouts = { layout = my_layout },
    -- picker_preview = { layout = my_layout },
    projects = { layout = my_layout },
    qflist = { layout = my_layout },
    recent = { layout = my_layout },
    registers = { layout = my_layout },
    resume = { layout = my_layout },
    search_history = { layout = my_layout },
    -- select = { layout = my_layout },
    smart = { layout = my_layout },
    spelling = { layout = my_layout },
    treesitter = { layout = my_layout },
    undo = { layout = my_layout },
    zoxide = { layout = my_layout },
  }
}

local explorer     = {
  replace_netrw = true,
}

local statuscolumn = {
  enabled = true,
  folds = {
    open = false,  -- show open fold icons
    git_hl = true, -- use Git Signs hl for fold icons
  },
}


return {
  "folke/snacks.nvim",
  enabled = true,
  event = "VeryLazy",
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = false },
    bigfile = { enabled = false },
    dashboard = dashboard,
    dim = { enabled = false },
    explorer = explorer,
    gitbrowse = gitbrowse,
    indent = indent,
    input = {},
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = picker,
    profiler = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scratch = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = statuscolumn,
    styles = { enabled = false },
    terminal = { enabled = false },
    toggle = { enabled = false },
    win = { enabled = false },
    words = { enabled = false },
    zen = { enabled = false },
  },
  keys = {
    --
    { "<C-w>Z",  function() Snacks.zen() end,                desc = "Toggle Zen Mode" },
    { "<C-w>z",  function() Snacks.zen.zoom() end,           desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
    -- { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    -- { "<leader>td", function() Snacks.bufdelete() end, desc = "Delete Buffer" },  -- TODO this makes the bufffers blank
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
    -- Picker

    -- Search
    { "<leader>/",  function() Snacks.picker.grep() end,            desc = "Grep" },
    { "<leader>s:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end,        desc = "Commands" },
    { "<leader>sH", function() Snacks.picker.highlights() end,      desc = "Highlights" },
    { "<leader>sK", function() Snacks.picker.colorschemes() end,    desc = "Colorschemes" },
    { "<leader>sL", function() Snacks.picker.lazy() end,            desc = "Search for Plugin Spec" },
    { "<leader>sM", function() Snacks.picker.man() end,             desc = "Man Pages" },
    { "<leader>sS", function() Snacks.search_history() end,         desc = "history" },
    { "<leader>sw", function() Snacks.picker.grep_word() end,       desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>sb", function() Snacks.picker.grep_buffers() end,    desc = "Grep Open Buffers" },
    { "<leader>sc", function() Snacks.picker.resume() end,          desc = "Resume" },
    { "<leader>sh", function() Snacks.picker.help() end,            desc = "Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end,           desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end,           desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end,         desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end,         desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end,           desc = "Marks" },
    { "<leader>sq", function() Snacks.picker.qflist() end,          desc = "Quickfix List" },
    { "<leader>ss", function() Snacks.picker.grep() end,            desc = "Grep" },
    { "<leader>su", function() Snacks.picker.undo() end,            desc = "Undo History" },
    { '<leader>s"', function() Snacks.picker.registers() end,       desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end,  desc = "Search History" },
    -- Navigation
    {
      "<M-e>",
      function()
        Snacks.explorer(
        -- { layout = { preset = "sidebar", preview = false } }
        )
      end,
      desc = "File Explorer"
    },
    -- Buffers
    { "<leader><space>", function() Snacks.picker.smart({ filter = { cwd = true } }) end,  desc = "Smart Find Files" },
    { "<leader>tr",      function() Snacks.picker.buffers({ current = false }) end,        desc = "Buffers" },
    { "<leader>,",       function() Snacks.picker.buffers() end,                           desc = "Buffers" },
    { "<leader>to",      function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent" },
    -- GOTO
    { "<leader>gp",      function() Snacks.picker.projects() end,                          desc = "Projects" },
    { "<leader>gf",      function() Snacks.picker.files() end,                             desc = "Find Files" },
    { "<leader>gh",      function() Snacks.picker.help() end,                              desc = "Help Pages" },
    -- Diagnostics
    { "<leader>db",      function() Snacks.picker.diagnostics_buffer() end,                desc = "Buffer Diagnostics" },
    {
      "<leader>dw",
      function()
        Snacks.picker.diagnostics({
          sort = {
            fields = {
              "severity",
              "is_current",
              "is_cwd",
              "file",
              "lnum",
            },
          }
        })
      end,
      desc = "Diagnostics"
    },
    -- Git
    { "<leader>mB",  function() Snacks.picker.git_branches() end,          desc = "Git Branches" },
    { "<leader>mL",  function() Snacks.lazygit.log() end,                  desc = "Lazygit Log (cwd)" },
    -- { "<leader>ml",  function() Snacks.lazygit.open() end,                 desc = "Lazygit" },
    { "<leader>mV",  function() Snacks.git.blame_line() end,               desc = "Git Blame Line" },
    { "<leader>mH",  function() Snacks.lazygit.log_file() end,             desc = "Lazygit Current File History" },
    { "<leader>mg",  function() Snacks.lazygit() end,                      desc = "Lazygit" },
    { "<leader>mxg", function() Snacks.picker.git_files() end,             desc = "Find Git Files" },
    { "<leader>mxl", function() Snacks.picker.git_log() end,               desc = "Git Log" },
    { "<leader>mxL", function() Snacks.picker.git_log_line() end,          desc = "Git Log Line" },
    { "<leader>ms",  function() Snacks.picker.git_status() end,            desc = "Git Status" },
    { "<leader>mS",  function() Snacks.picker.git_stash() end,             desc = "Git Stash" },
    { "<leader>md",  function() Snacks.picker.git_diff() end,              desc = "Git Diff (Hunks)" },
    { "<leader>mF",  function() Snacks.picker.git_log_file() end,          desc = "Git Log File" },
    -- LSP
    { "<leader>gD",  function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "<leader>gS",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>gd",  function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "<leader>gi",  function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "<leader>gr",  function() Snacks.picker.lsp_references() end,        nowait = true,                        desc = "References" },
    { "<leader>gs",  function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>gt",  function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },

    -- Misc
    { "<leader>:",   function() Snacks.picker.command_history() end,       desc = "Command History" },
    { "<leader>nd",  function() Snacks.notifier.hide() end,                desc = "Dismiss All Notifications" },
    { "<leader>nn",  function() Snacks.picker.notifications() end,         desc = "Notification History" },
    { "[[",          function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",              mode = { "n", "t" } },
    { "]]",          function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",              mode = { "n", "t" } },

    -- TODO
    { "<leader>xx",  function() Snacks.gitbrowse() end,                    desc = "Git Browse",                  mode = { "n", "v" } },
    { "<leader>xy",  function() Snacks.gitbrowse().open() end,             desc = "Git Browse open",             mode = { "n", "v" } },
  },
}
