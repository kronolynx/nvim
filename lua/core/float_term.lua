local M = {}
-- Lazy terminal
-- https://github.com/folke/lazy.nvim/blob/main/lua/lazy/view/float.lua
-- flaot_term
-- https://github.com/folke/lazy.nvim/blob/6c3bda4aca61a13a9c63f1c1d1b16b9d3be90d7a/lua/lazy/util.lua#L135
--
local default_opts = {
  ft = 'lazyterm',
  persistent = true,
  win = {
    title_pos = "left",
    title = "test",
    border = "rounded",
    backdrop = false,
    width = 0.9,
    height = 0.9
  }
}

---@type LazyFloat?
local float_term = nil

--- Opens an interactive floating terminal.
---@param cmd? string
---@param opts? LazyCmdOptions
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})

  if float_term and float_term:buf_valid() and vim.b[float_term.buf].lazyterm_cmd == cmd then
    float_term:toggle()
  else
    float_term = require('lazy.util').float_term(cmd, opts)
    vim.b[float_term.buf].lazyterm_cmd = cmd
  end
end

---@type table<number, LazyFloat?>
local terminals = {}
local current_index = 1 -- TODO last count is lost
local default_shell = os.getenv('SHELL') or 'sh'

--- Opens multiple interactive floating terminals with default shell.
---@param opts? LazyCmdOptions
function M.toggle_term(opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  local function toggle_or_create(term_index)
    local terminal = terminals[term_index]
    if terminal and terminal:buf_valid() then
      terminal:toggle()
      -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>i', true, true, true), 'n', true)
    else
      opts.win.title = "[" .. term_index .. "]"
      terminal = Snacks.terminal.get(default_shell, opts)
      terminals[term_index] = terminal
    end
  end

  local count = vim.v.count

  if count == 0 then
    toggle_or_create(current_index)
  else
    local terminal = terminals[current_index]
    if terminal and terminal:win_valid() then
      -- if a terminal is already open just close as we don't want terminals to overlap
      terminal:hide()
    else
      current_index = count
      toggle_or_create(current_index)
    end
  end
end

return M
