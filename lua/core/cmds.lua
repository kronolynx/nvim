-- Function to grep the word under the cursor
function _G.grep_word_under_cursor()
  local word = vim.fn.expand('<cword>')
  vim.cmd('Grep ' .. word)
end

-- Function to prompt for grep arguments and run the Grep command
function _G.prompt_grep()
  local pattern = vim.fn.input('Grep pattern: ')
  if pattern ~= '' then
    vim.cmd('Grep ' .. pattern)
  end
end

vim.api.nvim_create_user_command('Grep', function(opts)
  vim.cmd('silent grep ' .. table.concat(opts.fargs, ' '))
  vim.cmd('redraw!')
  vim.cmd('copen')
end, { nargs = '+', complete = 'file' })
