local icons = require 'util.icons'

-- :help 'statusline'

local M = {}

--------------------------------------------------
------------------- SETTINGS ---------------------
--------------------------------------------------
-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

-- Show the mode in my custom component instead.
vim.o.showmode = false

local colors = {
  bright_bg = "#363954", -- TODO make it a bit  different
  bright_fg = "Folded",
  red = "DiagnosticError",
  dark_red = "DiffDelete",
  green = "String", -- TODO find a better green
  blue = "Function",
  gray = "NonText",
  orange = "Constant",
  purple = "Statement",
  cyan = "Operator", -- TODO this is pink not cyan
  diag_warn = "DiagnosticWarn",
  diag_error = "DiagnosticError",
  diag_hint = "DiagnosticHint",
  diag_info = "DiagnosticInfo",
  git_del = "diffRemoved",
  git_add = "diffAdded",
  git_change = "diffChanged",
}

--------------------------------------------------
------------------- HELPERS ----------------------
--------------------------------------------------


-- souce: https://github.com/rebelot/heirline.nvim/blob/fae936abb5e0345b85c3a03ecf38525b0828b992/lua/heirline/conditions.lua#L4
M.conditions = {}

local function pattern_list_matches(str, pattern_list)
  for _, pattern in ipairs(pattern_list) do
    if str:find(pattern) then
      return true
    end
  end
  return false
end

local buf_matchers = {
  filetype = function(bufnr)
    return vim.bo[bufnr].filetype
  end,
  buftype = function(bufnr)
    return vim.bo[bufnr].buftype
  end,
  bufname = function(bufnr)
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  end,
}

function M.conditions.buffer_matches(patterns, bufnr)
  bufnr = bufnr or 0
  for kind, pattern_list in pairs(patterns) do
    if pattern_list_matches(buf_matchers[kind](bufnr), pattern_list) then
      return true
    end
  end
  return false
end

function M.conditions.width_percent_below(n, thresh, is_winbar)
  local winwidth
  if vim.o.laststatus == 3 and not is_winbar then
    winwidth = vim.o.columns
  else
    winwidth = vim.api.nvim_win_get_width(0)
  end

  return n / winwidth <= thresh
end

--- source: https://github.com/idr4n/nvim-lua/blob/89ca7cf3209af446b88d91f6c9c70aa6c56ef323/lua/config/statusline/components.lua#L150
---Keeps track of the highlight groups already created.
---@type table<string, boolean>
local statusline_hls = {}

---@param hl_bg? string
---@param hl_fg string
---@return string
function M.get_or_create_hl(hl_fg, hl_bg)
  hl_bg = hl_bg or "StatusLine"
  local sanitized_hl_fg = hl_fg:gsub("#", "")
  local sanitized_hl_bg = hl_bg:gsub("#", "")
  local hl_name = "SL" .. sanitized_hl_fg .. sanitized_hl_bg

  if not statusline_hls[hl_name] then
    -- If not in the cache, create the highlight group
    local bg_hl
    if hl_bg:match("^#") then
      -- If hl_bg starts with #, it's a hex color
      bg_hl = { bg = hl_bg }
    else
      -- Otherwise treat it as highlight group name
      bg_hl = vim.api.nvim_get_hl(0, { name = hl_bg })
    end

    local fg_hl
    if hl_fg:match("^#") then
      -- If hl_fg starts with #, it's a hex color
      fg_hl = { fg = hl_fg }
    else
      -- Otherwise treat it as highlight group name
      fg_hl = vim.api.nvim_get_hl(0, { name = hl_fg })
    end

    if not bg_hl.bg then
      bg_hl = vim.api.nvim_get_hl(0, { name = "Statusline" })
    end
    if not fg_hl.fg then
      fg_hl = vim.api.nvim_get_hl(0, { name = "Statusline" })
    end


    vim.api.nvim_set_hl(0, hl_name, {
      bg = bg_hl.bg and (type(bg_hl.bg) == "string" and bg_hl.bg or ("#%06x"):format(bg_hl.bg)) or "none",
      fg = fg_hl.fg and (type(fg_hl.fg) == "string" and fg_hl.fg or ("#%06x"):format(fg_hl.fg)) or "none",
    })
    statusline_hls[hl_name] = true
  end

  return "%#" .. hl_name .. "#"
end

---@param components string[]
---@return string
local function concat_components(components)
  return vim.iter(components):skip(1):fold(components[1], function(acc, component)
    return #component > 0 and acc .. ' ' .. component or acc
  end)
end

--------------------------------------------------
------------------- COMPONENTS -------------------
--------------------------------------------------

function M.endBar()
  local hl = M.get_or_create_hl(colors.blue)
  return hl .. '▊'
end

--- Current mode.
---@return string
function M.mode_component()
  -- Note that: \19 = ^S and \22 = ^V.
  local mode_to_str = {
    ['n'] = 'NORMAL',
    ['no'] = 'OP-PENDING',
    ['nov'] = 'OP-PENDING',
    ['noV'] = 'OP-PENDING',
    ['no\22'] = 'OP-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['ntT'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['vs'] = 'VISUAL',
    ['V'] = 'VISUAL',
    ['Vs'] = 'VISUAL',
    ['\22'] = 'VISUAL',
    ['\22s'] = 'VISUAL',
    ['s'] = 'SELECT',
    ['S'] = 'SELECT',
    ['\19'] = 'SELECT',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rc'] = 'REPLACE',
    ['Rx'] = 'REPLACE',
    ['Rv'] = 'VIRT REPLACE',
    ['Rvc'] = 'VIRT REPLACE',
    ['Rvx'] = 'VIRT REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'VIM EX',
    ['ce'] = 'EX',
    ['r'] = 'PROMPT',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
  }

  local mode_colors = {
    Normal = colors.red,
    Pending = colors.purple,
    Visual = colors.cyan,
    Insert = colors.green,
    Command = colors.orange,
    Other = colors.gray
  }

  -- Get the respective string to display.
  local mode = mode_to_str[vim.api.nvim_get_mode().mode] or 'UNKNOWN'

  -- Set the highlight group.
  local hl = 'Other'
  if mode:find 'NORMAL' then
    hl = mode_colors['Normal']
  elseif mode:find 'PENDING' then
    hl = mode_colors['Pending']
  elseif mode:find 'VISUAL' then
    hl = mode_colors['Visual']
  elseif mode:find 'INSERT' or mode:find 'SELECT' then
    hl = mode_colors['Insert']
  elseif mode:find 'COMMAND' or mode:find 'TERMINAL' or mode:find 'EX' then
    hl = mode_colors['Command']
  end

  local separator_hl = M.get_or_create_hl(colors.bright_bg)
  local mode_hl = M.get_or_create_hl(hl, colors.bright_bg)

  -- Construct the bubble-like component.
  return separator_hl .. '' .. mode_hl .. ' ' .. separator_hl .. ''
end

---@return string
function M.git_changes_component()
  local head = vim.b.gitsigns_head
  if not head or head == '' then
    return ''
  end

  local component = ''

  local status_dict = vim.b.gitsigns_status_dict

  local add_count = status_dict.added or 0
  local add_hl = M.get_or_create_hl(colors.git_add)
  component = (add_count > 0 and (add_hl .. ' ' .. add_count) or "")

  local del_count = status_dict.removed or 0
  local del_hl = M.get_or_create_hl(colors.git_del)
  component = component .. (del_count > 0 and (del_hl .. ' ' .. del_count) or "")

  local change_count = status_dict.changed or 0
  local change_hl = M.get_or_create_hl(colors.git_change)
  component = component .. (change_count > 0 and (change_hl .. ' ' .. change_count) or "")

  return component
end

--- Git status (if any).
---@return string
function M.git_branch_component()
  local head = vim.b.gitsigns_head
  if not head or head == '' then
    return ''
  end

  local hl = M.get_or_create_hl(colors.purple)

  return hl .. ' ' .. head
end

--- File-content encoding for the current buffer.
---@return string
function M.filename_component()
  local window = vim.g.statusline_winid;
  --- Buffer of the window.
  ---@type integer
  local buffer = vim.api.nvim_win_get_buf(window);
  local filename = vim.api.nvim_buf_get_name(buffer)

  local extension = vim.fn.fnamemodify(filename, ":e")
  local icon, icon_hl = require("nvim-web-devicons").get_icon(filename, extension,
    { default = true })
  icon_hl = M.get_or_create_hl(icon_hl)
  local lfilename = vim.fn.fnamemodify(filename, ":.")

  if lfilename == "" then lfilename = "[No Name]" end

  if not M.conditions.width_percent_below(#lfilename, 0.25) then
    lfilename = vim.fn.pathshorten(lfilename, 2)
  end

  local filename_hl = M.get_or_create_hl(colors.blue)
  lfilename = filename_hl .. lfilename

  local flag = ""
  if vim.bo.modified then
    local hl = M.get_or_create_hl(colors.green)
    flag = hl .. "[+]"
  elseif not vim.bo.modifiable or vim.bo.readonly then
    local hl = M.get_or_create_hl(colors.orange)
    flag = hl .. ""
  end

  return icon_hl .. icon .. ' ' .. lfilename .. flag
end

---@return string
function M.active_lsp_component()
  local dev_icons_color = require("nvim-web-devicons").get_icon_color_by_filetype

  local dev_icons = function(ext)
    local icon, hl = dev_icons_color(ext)
    return { icon = icon, hl = hl }
  end
  local lsp_icons = {
    lua_ls = dev_icons("lua"),
    copilot = { icon = "", hl = colors.blue },
    metals = dev_icons("scala"),
    pyright = dev_icons("python"),
    kotlin_language_server = dev_icons("kotlin"),
    jsonls = dev_icons("json"),
    rust_analyzer = dev_icons("rust"),
    yamlls = dev_icons("yaml"),
    bashls = dev_icons("bash"),
    marksman = dev_icons("markdown"),
  }
  local icon_or_name = {}

  for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local lsp_icon = lsp_icons[server.name] or { icon = server.name, hl = colors.cyan }

    local hl = M.get_or_create_hl(lsp_icon.hl)

    table.insert(icon_or_name, hl .. lsp_icon.icon)
  end

  -- TODO use different colors for icons
  local hl = M.get_or_create_hl(colors.cyan)

  return hl .. table.concat(icon_or_name, " ") .. " "
end

--- File-content encoding for the current buffer.
---@return string
function M.workdir_component()
  local icon = "  "
  -- see :help filename-modifiers
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ":t")
  local hl = M.get_or_create_hl(colors.blue)
  return hl .. icon .. cwd
end

--- The current line, total line count, and column position.
---@return string
function M.scrollbar_component()
  local sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)
  local i = math.floor((curr_line - 1) / lines * #sbar) + 1

  local hl = M.get_or_create_hl(colors.blue)

  return hl .. string.rep(sbar[i], 2)
end

---@return string
function M.file_format_component()
  local fmt = vim.bo.fileformat
  local hl = M.get_or_create_hl(colors.orange)
  return fmt ~= 'unix' and (hl .. ' ' .. fmt:upper()) or ""
end

---@return string
function M.file_encoding_component()
  local enc = ((vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc):upper() -- :h 'enc'
  local hl = M.get_or_create_hl(colors.orange)
  return enc ~= 'UTF-8' and hl .. enc or ""
end

-- Macro
---@return string
function M.macro_component()
  local component = ""
  local recording = vim.fn.reg_recording()
  if recording ~= "" and vim.o.cmdheight == 0 then
    local icon = icons.misc.circle_dot
    local hl = M.get_or_create_hl(colors.orange)
    local rec_hl = M.get_or_create_hl(colors.green)

    component = hl .. icon .. " [" .. rec_hl .. recording .. hl .. "]"
  end
  return component
end

-- Search_count
---@return string
function M.search_count_component()
  local component = ""
  if vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0 then
    local hl = M.get_or_create_hl(colors.gray)

    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      search = search
    end
    component = string.format("%s[%d/%d]", hl, search.current, math.min(search.total, search.maxcount))
  end
  return component
end

---@return string
--- The current line, total line count, and column position.
function M.ruler_component()
  local hl = M.get_or_create_hl(colors.gray)
  return hl .. "%7(%l/%3L%):%2c %P"
end

local last_diagnostic_component = ''
--- Diagnostic counts in the current buffer.
---@return string
function M.diagnostics_component()
  -- Lazy uses diagnostic icons, but those aren't errors per se.
  if vim.bo.filetype == 'lazy' then
    return ''
  end

  -- Use the last computed value if in insert mode.
  if vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
    return last_diagnostic_component
  end

  local counts = vim.iter(vim.diagnostic.get(0)):fold({
    ERROR = 0,
    WARN = 0,
    HINT = 0,
    INFO = 0,
  }, function(acc, diagnostic)
    local severity = vim.diagnostic.severity[diagnostic.severity]
    acc[severity] = acc[severity] + 1
    return acc
  end)

  local parts = vim.iter(counts)
      :map(function(severity, count)
        if count == 0 then
          return nil
        end

        local hl = 'Diagnostic' .. severity:sub(1, 1) .. severity:sub(2):lower()

        return M.get_or_create_hl(hl) .. icons.diagnostics[severity] .. ' ' .. count
      end)
      :totable()

  return table.concat(parts, ' ')
end

function M.filetype_component()
  local hl = M.get_or_create_hl("Type")
  return hl .. string.upper(vim.bo.filetype)
end

function M.terminal_component()
  local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
  local hl = M.get_or_create_hl(colors.blue)
  return hl .. " " .. tname
end

function M.help_file_component()
  local component = ""
  if vim.bo.filetype == "help" then
    local hl = M.get_or_create_hl(colors.blue)
    local filename = vim.api.nvim_buf_get_name(0)
    -- see :help filename-modifiers
    component = hl .. vim.fn.fnamemodify(filename, ":t")
  end
  return component
end

--------------------------------------------------
------------------- RENDER -----------------------
--------------------------------------------------

---@return string
function M.render_active()
  return table.concat {
    M.endBar(),
    M.mode_component(),
    M.macro_component(),
    concat_components {
      M.workdir_component(),
      M.filename_component(),
      M.diagnostics_component()
    },
    '%#StatusLine#%=',
    concat_components {
      M.search_count_component(),
      M.active_lsp_component(),
      M.git_branch_component(),
      M.git_changes_component(),
      M.file_format_component(),
      M.file_encoding_component(),
      M.ruler_component(),
      M.scrollbar_component(),
      M.endBar(),
    },
  }
end

function M.render_special()
  return table.concat {
    concat_components {
      M.filetype_component(),
      M.help_file_component(),
    },
    '%#StatusLine#%=',
  }
end

function M.render_terminal()
  return table.concat {
    concat_components {
      M.filetype_component(),
      M.terminal_component()
    },
    '%#StatusLine#%=',
  }
end

function M.render_inactive()
  return table.concat {
    concat_components {
      M.workdir_component(),
      M.filename_component(),
    },
    '%#StatusLine#%=',
    M.git_branch_component(),
  }
end

function M.render()
  if M.conditions.buffer_matches({ buftype = { "terminal" } }) then
    return M.render_terminal()
  elseif M.conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      }) then
    return M.render_special()
  else
    return M.render_active()
  end
end

vim.api.nvim_create_augroup("Statusline", { clear = true })

-- Set the statusline when entering or leaving a window/buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = "Statusline",
  callback = function()
    vim.wo.statusline = "%!v:lua.require'core.statusline'.render()"
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "Statusline",
  callback = function()
    vim.wo.statusline = "%!v:lua.require'core.statusline'.render_inactive()"
  end,
})

return M
