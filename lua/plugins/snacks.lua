vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
}, { confirm = false })

-- for debugging
-- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
-- _G.dd              = function(...)
--   Snacks.debug.inspect(...)
-- end
-- _G.bt              = function()
--   Snacks.debug.backtrace()
-- end
-- vim.print          = _G.dd

local gitbrowse    = {
  what = "permalink",
  url_patterns = {
    ["github%.com"] = {
      branch = "/tree/{branch}",
      file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
      permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
      commit = "/commit/{commit}",
    },
    ["gitlab[%w%.]*%.com"] = {
      branch = "/-/tree/{branch}",
      file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
      permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
      commit = "/-/commit/{commit}",
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
  win = {
    input = {
      keys = {
        ["<s-h>"] = { "toggle_hidden", mode = { "n" } },
        ["<s-i>"] = { "toggle_ignored", mode = { "n" } },
        ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
      }
    }
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
        hidden = { "preview" },
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

vim.defer_fn(function()
  require("snacks").setup({
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
  })



  vim.keymap.set("n", "<C-w>Z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
  vim.keymap.set("n", "<C-w>z", function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
  vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  vim.keymap.set("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
  -- vim.keymap.set("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
  -- vim.keymap.set("n", "<leader>td", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })  -- TODO this makes the bufffers blank
  vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  vim.keymap.set("n", "<leader>N", function()
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
  end, { desc = "Neovim News" })

  -- Picker
  -- Search
  vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
  vim.keymap.set("n", "<leader>s:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
  vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
  vim.keymap.set("n", "<leader>sK", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
  vim.keymap.set("n", "<leader>sL", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
  vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
  vim.keymap.set("n", "<leader>sS", function() Snacks.search_history() end, { desc = "history" })
  vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end,
    { desc = "Visual selection or word" })
  vim.keymap.set("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  vim.keymap.set("n", "<leader>sc", function() Snacks.picker.resume() end, { desc = "Resume" })
  vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
  vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
  vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
  vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
  vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
  vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
  vim.keymap.set("n", "<leader>ss", function() Snacks.picker.grep() end, { desc = "Grep" })
  vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
  vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
  vim.keymap.set("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" })

  -- Navigation
  vim.keymap.set("n", "<M-e>", function()
    Snacks.explorer(
    -- { layout = { preset = "sidebar", preview = false } }
    )
  end, { desc = "File Explorer" })

  -- Buffers
  vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart({ filter = { cwd = true } }) end,
    { desc = "Smart Find Files" })
  vim.keymap.set("n", "<leader>tr", function() Snacks.picker.buffers({ current = false }) end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>to", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent" })

  -- GOTO
  vim.keymap.set("n", "<leader>gp", function() Snacks.picker.projects() end, { desc = "Projects" })
  vim.keymap.set("n", "<leader>gf", function() Snacks.picker.files() end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>gh", function() Snacks.picker.help() end, { desc = "Help Pages" })

  -- Diagnostics
  vim.keymap.set("n", "<leader>db", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  vim.keymap.set("n", "<leader>dw", function()
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
  end, { desc = "Diagnostics" })

  -- Git
  vim.keymap.set("n", "<leader>mB", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
  vim.keymap.set("n", "<leader>mL", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
  -- vim.keymap.set("n", "<leader>ml", function() Snacks.lazygit.open() end, { desc = "Lazygit" })
  vim.keymap.set("n", "<leader>mv", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
  vim.keymap.set("n", "<leader>mH", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
  vim.keymap.set("n", "<leader>mg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  vim.keymap.set("n", "<leader>mxg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  vim.keymap.set("n", "<leader>mxl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  vim.keymap.set("n", "<leader>mxL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
  vim.keymap.set("n", "<leader>ms", function() Snacks.picker.git_status() end, { desc = "Git Status" })
  vim.keymap.set("n", "<leader>mS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
  vim.keymap.set("n", "<leader>md", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
  vim.keymap.set("n", "<leader>mF", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })

  -- LSP
  vim.keymap.set("n", "<leader>gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
  vim.keymap.set("n", "<leader>gS", function() Snacks.picker.lsp_workspace_symbols() end,
    { desc = "LSP Workspace Symbols" })
  vim.keymap.set("n", "<leader>gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
  vim.keymap.set("n", "<leader>gi", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
  vim.keymap.set("n", "<leader>gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
  vim.keymap.set("n", "<leader>gs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
  vim.keymap.set("n", "<leader>gt", function() Snacks.picker.lsp_type_definitions() end,
    { desc = "Goto T[y]pe Definition" })

  -- Misc
  vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  vim.keymap.set("n", "<leader>nd", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
  vim.keymap.set("n", "<leader>nn", function() Snacks.picker.notifications() end, { desc = "Notification History" })
  vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
  vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })

  vim.keymap.set({ "n", "v" }, "<leader>mY", function()
    Snacks.gitbrowse.open({
      open = function(url)
        vim.fn.setreg("+", url)
        vim.notify("Yanked url to clipboard " .. url)
      end,
    })
  end, { desc = "Git Copy Link" })
  vim.keymap.set({ "n", "v" }, "<leader>my", function() Snacks.gitbrowse() end, { desc = "Git Browse open" })
end, 200)
