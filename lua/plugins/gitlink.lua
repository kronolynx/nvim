-- Generate and handle permalinks to specific lines in Git repositories hosted on platforms like GitHub and GitLab.

-- Define URL patterns for supported git hosting services
local url_patterns = {
  ["github%.com"] = {
    permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
  },
  ["gitlab[%w%.]*%.com"] = {
    permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
  },
}

local function get_permalink(mode)
  mode = mode or 'n'
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if not git_root or git_root == '' then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end
  local relpath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.'):gsub('^' .. git_root .. '/', '')

  -- Get commit hash
  local commit = vim.fn.systemlist('git rev-parse HEAD')[1]

  -- Get remote URL
  local remote_url = vim.fn.systemlist('git remote get-url origin')[1]
  if not remote_url or remote_url == '' then
    vim.notify('No git remote found', vim.log.levels.ERROR)
    return
  end

  -- Normalize remote_url for SSH or HTTPS
  remote_url = remote_url:gsub('%.git$', '')
  remote_url = remote_url:gsub(':', '/')
  local host, user, repo = remote_url:match('https?://([^/]+)/([^/]+)/(.+)')
  if not host then
    host, user, repo = remote_url:match('git@([^/]+)/([^/]+)/(.+)')
  end
  if not (host and user and repo) then
    vim.notify('Could not parse remote URL: ' .. remote_url, vim.log.levels.ERROR)
    return
  end

  -- Find matching pattern
  local matched_pattern
  for pattern, conf in pairs(url_patterns) do
    if host:match(pattern) then
      matched_pattern = conf.permalink
      break
    end
  end

  if not matched_pattern then
    vim.notify('Unsupported remote host: ' .. host, vim.log.levels.ERROR)
    return
  end

  local url_base = string.format("https://%s/%s/%s", host, user, repo)

  -- Handle visual or normal mode selection
  local line_start, line_end

  if mode == "v" then
    local pos1 = vim.fn.getpos("v")[2]
    local pos2 = vim.fn.getcurpos()[2]
    line_start = math.min(pos1, pos2)
    line_end = math.max(pos1, pos2)
  else
    line_start = vim.api.nvim_win_get_cursor(0)[1]
    line_end = line_start
  end

  -- Build permalink
  local url = url_base .. matched_pattern
  url = url
      :gsub('{commit}', commit)
      :gsub('{file}', relpath)
      :gsub('{line_start}', tostring(line_start))
      :gsub('{line_end}', tostring(line_end))

  return url
end

local function copy_to_clipboard(mode)
  local url = get_permalink(mode)
  if not url or url == '' then
    vim.notify('No URL to copy', vim.log.levels.ERROR)
    return
  end
  vim.fn.setreg('+', url)
  vim.notify('Copied to clipboard:\n' .. url)
end

local function open_in_browser(mode)
  local url = get_permalink(mode)
  if not url or url == '' then
    vim.notify('No URL to open', vim.log.levels.ERROR)
    return
  end

  -- Choose the right open command depending on OS
  local open_cmd
  if vim.fn.has('macunix') == 1 then
    open_cmd = { 'open', url }
  elseif vim.fn.has('unix') == 1 then
    open_cmd = { 'xdg-open', url }
  elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    open_cmd = { 'cmd', '/c', 'start', url }
  else
    vim.notify('Unsupported OS for opening URLs', vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart(open_cmd, { detach = true })
  vim.notify('Opened in browser:\n' .. url)
end

-- vim.keymap.set("n", "<leader>my", function() copy_to_clipboard('n') end, { desc = "Copy permalink" })
-- vim.keymap.set("v", "<leader>my", function() copy_to_clipboard('v') end, { desc = "Copy permalink" })
-- vim.keymap.set("n", "<leader>mo", function() open_in_browser('n') end, { desc = "Open permalink" })
-- vim.keymap.set("v", "<leader>mo", function() open_in_browser('v') end, { desc = "Open permalink" })

vim.keymap.set({ "n", "v" }, "<leader>my", function()
  local mode = vim.fn.mode():match('[vV\22]') and 'v' or 'n'
  copy_to_clipboard(mode)
end, { desc = "Copy permalink" })

vim.keymap.set({ "n", "v" }, "<leader>mo", function()
  local mode = vim.fn.mode():match('[vV\22]') and 'v' or 'n'
  open_in_browser(mode)
end, { desc = "Open permalink" })
