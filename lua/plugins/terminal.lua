local M = {}

local default_opts = {
  cmd = os.getenv('SHELL') or 'sh',
  position = "float", -- "float", "above", "below", "left", "right"
  title_pos = "left",
  title = '',
  border = "rounded",
  auto_close = true,
  width = 0.9,
  height = 0.9
}

local terminals = {}
local current_index = 1

local Terminal = {}
Terminal.__index = Terminal

function Terminal:new(opts)
  local t = setmetatable({}, self)

  t.opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  t.buf = vim.api.nvim_create_buf(false, true)
  return t
end

function Terminal:show()
  local win_config
  if self.opts.position == "float" then
    local width = math.floor(vim.o.columns * self.opts.width)
    local height = math.floor(vim.o.lines * self.opts.height)

    win_config = {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) * 0.5),
      col = math.floor((vim.o.columns - width) * 0.5),
      style = "minimal",
      border = self.opts.border,
      title = self.opts.title,
      title_pos = self.opts.title_pos,
    }
  else
    win_config = {
      style = "minimal",
      split = self.opts.position,
      win = 0
    }
  end

  self.win = vim.api.nvim_open_win(self.buf, true, win_config)
  if vim.bo[self.buf].buftype ~= "terminal" then
    vim.fn.jobstart(self.opts.cmd, {
      term = true,
      on_exit = function()
        if self.opts.auto_close then
          if self:win_valid() then
            vim.api.nvim_win_close(self.win, true)
          end
          if self:buf_valid() then
            current_index = 1
            vim.api.nvim_buf_delete(self.buf, { force = true })
          end
        end
      end
    })
  end

  vim.cmd.startinsert()
end

function Terminal:buf_valid()
  return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

function Terminal:win_valid()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

function Terminal:hide()
  if self.win then
    vim.api.nvim_win_hide(self.win)
  end
end

function Terminal:toggle()
  if not self:win_valid() then
    self:show()
  else
    self:hide()
  end
end

function M.toggle_term(opts)
  opts = opts or {}
  local function toggle_or_create(term_index)
    local terminal = terminals[term_index]
    if not (terminal and terminal:buf_valid()) then
      opts.title = opts.title or ("[" .. term_index .. "]")
      terminal = Terminal:new(opts)
      terminals[term_index] = terminal
    end
    terminal:toggle()
  end

  local terminal = terminals[current_index]
  if terminal and terminal:win_valid() then
    -- if a terminal is already open just close it as we don't want terminals to overlap
    terminal:hide()
  else
    local count = vim.v.count
    current_index = opts.index or (count == 0 and current_index or count)
    toggle_or_create(current_index)
  end
end

vim.keymap.set({ "n", "t" }, "<M-t>", function()
  M.toggle_term()
end, { noremap = true, silent = true, desc = "Toggle floating terminal" })

vim.keymap.set({ "n" }, "<leader>xv", function()
  M.toggle_term({ position = "below" })
end, { noremap = true, silent = true, desc = "Toggle split terminal" })

vim.keymap.set({ "n" }, "<leader>lms", function()
  M.toggle_term({ cmd = "sbt", title = "sbt", index = 999 })
end, { noremap = true, silent = true, desc = "Toggle sbt terminal" })

vim.keymap.set({ "n" }, "<leader>ml", function()
  M.toggle_term({ cmd = "lazygit", title = "Lazygit", index = 998 })
end, { noremap = true, silent = true, desc = "Toggle lazy terminal" })

return M
